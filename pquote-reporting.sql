DROP TABLE if exists `DIM_STATES`;

create table `DIM_STATES`
(
`state_id`   smallint    unsigned not null auto_increment comment 'PK: State ID',
`state_name` varchar(32) not null comment 'State name with first letter capital',
`state_abbr` varchar(8)  comment 'Optional state abbreviation (US 2 cap letters)',
primary key (state_id)
);

insert into `DIM_STATES`
values
(NULL, 'Alabama', 'AL'),
(NULL, 'Alaska', 'AK'),
(NULL, 'Arizona', 'AZ'),
(NULL, 'Arkansas', 'AR'),
(NULL, 'California', 'CA'),
(NULL, 'Colorado', 'CO'),
(NULL, 'Connecticut', 'CT'),
(NULL, 'Delaware', 'DE'),
(NULL, 'District of Columbia', 'DC'),
(NULL, 'Florida', 'FL'),
(NULL, 'Georgia', 'GA'),
(NULL, 'Hawaii', 'HI'),
(NULL, 'Idaho', 'ID'),
(NULL, 'Illinois', 'IL'),
(NULL, 'Indiana', 'IN'),
(NULL, 'Iowa', 'IA'),
(NULL, 'Kansas', 'KS'),
(NULL, 'Kentucky', 'KY'),
(NULL, 'Louisiana', 'LA'),
(NULL, 'Maine', 'ME'),
(NULL, 'Maryland', 'MD'),
(NULL, 'Massachusetts', 'MA'),
(NULL, 'Michigan', 'MI'),
(NULL, 'Minnesota', 'MN'),
(NULL, 'Mississippi', 'MS'),
(NULL, 'Missouri', 'MO'),
(NULL, 'Montana', 'MT'),
(NULL, 'Nebraska', 'NE'),
(NULL, 'Nevada', 'NV'),
(NULL, 'New Hampshire', 'NH'),
(NULL, 'New Jersey', 'NJ'),
(NULL, 'New Mexico', 'NM'),
(NULL, 'New York', 'NY'),
(NULL, 'North Carolina', 'NC'),
(NULL, 'North Dakota', 'ND'),
(NULL, 'Ohio', 'OH'),
(NULL, 'Oklahoma', 'OK'),
(NULL, 'Oregon', 'OR'),
(NULL, 'Pennsylvania', 'PA'),
(NULL, 'Rhode Island', 'RI'),
(NULL, 'South Carolina', 'SC'),
(NULL, 'South Dakota', 'SD'),
(NULL, 'Tennessee', 'TN'),
(NULL, 'Texas', 'TX'),
(NULL, 'Utah', 'UT'),
(NULL, 'Vermont', 'VT'),
(NULL, 'Virginia', 'VA'),
(NULL, 'Washington', 'WA'),
(NULL, 'West Virginia', 'WV'),
(NULL, 'Wisconsin', 'WI'),
(NULL, 'Wyoming', 'WY');

DROP TABLE if exists `DIM_MONTHS`;
CREATE TABLE `DIM_MONTHS`
(
  `month_id`   smallint    unsigned not null auto_increment comment 'PK: Month ID',
  `month_name` varchar(32) not null comment 'Full month name with year',
  `numeric_month` varchar(7)  comment 'YYYY-MM',
  `month` varchar(2)  comment 'MM',
  `year` varchar(4)  comment 'YYYY',
  primary key (month_id)
);

DROP TABLE if exists `FACT_QUOTES`;
CREATE TABLE `FACT_QUOTES`
  (
    `age`  int(11) NOT NULL,
    `creditScore` int(11) NOT NULL,
    `dlNumber` VARCHAR(50) NULL,
    `driverName`   VARCHAR(100) NOT NULL,
    `numberOfAccidents` int(11) NOT NULL,
    `numberOfTickets` int(11) NOT NULL,
    `ssn` int(11) NOT NULL,
    `policyType` VARCHAR(20) NULL,
    `price` int(11) NOT NULL,
    `priceDiscount` int(11) NOT NULL,
    `vehicleYear` int(11) NOT NULL,
    `processInstanceId` int(11) NOT NULL,
    `quote_month` smallint unsigned NOT NULL REFERENCES `DIM_MONTHS`.`month_id` ON DELETE CASCADE,
    `purchased` bit(1) NOT NULL DEFAULT 0,
    `bounced` bit(1) NOT NULL DEFAULT 0,
    `bounce_reason` varchar(10)
);

DROP TABLE if exists `FACT_INCIDENTS`;
CREATE TABLE `FACT_INCIDENTS`
  (
    `incident_month` smallint unsigned NOT NULL REFERENCES `DIM_MONTHS`.`month_id` ON DELETE CASCADE,
    `driver_age` INT(11) NOT NULL,
    `policy_age_months` INT(11) NOT NULL,
    `incident_reason` VARCHAR(20) NOT NULL,
    `state_id` smallint NOT NULL REFERENCES `DIM_STATES`(`state_id`) ON DELETE CASCADE,
    `driver_age_classification` VARCHAR(5) NOT NULL
);

DELIMITER //

DROP FUNCTION if exists `randomRangePicker`;
CREATE FUNCTION `randomRangePicker`
(
  minRange INT,
  maxRange INT
) RETURNS int(11)
BEGIN
  DECLARE pick INT;
  SET pick = minRange + FLOOR(RAND() * (maxRange - minRange + 1));
  RETURN pick;
END //
DROP FUNCTION if exists `randomSSN`;
CREATE FUNCTION `randomSSN`
() RETURNS VARCHAR(9)
BEGIN
  DECLARE ssn VARCHAR(9);
  DECLARE i TINYINT;
  SET i = 0;
  SET SSN = CONCAT('', randomRangePicker(1,9));
  label_s: LOOP
    SET i = i + 1;
    IF i <= 8 THEN
      SET SSN = CONCAT(SSN, randomRangePicker(0,9));
      ITERATE label_s;
    END IF;
    LEAVE label_s;
  END LOOP label_s;
  RETURN ssn;
END //
DROP PROCEDURE if exists `prc_generate_quote_mock`;
CREATE PROCEDURE prc_generate_quote_mock (IN idx INT)
BEGIN
  DECLARE lAgeMin INT;
  DECLARE lAgeMax INT;
  DECLARE lAge INT;

  DECLARE lBounced BIT;
  DECLARE lBounceReasonCode TINYINT;
  DECLARE lBounceReason VARCHAR(10);
  SET lBounced = 0;

  SET lAgeMin = 16;
  SET lAgeMax = 80;
  SET lAge = randomRangePicker(lAgeMin, lAgeMax);

  CASE WHEN randomRangePicker(1,4) < 4
    THEN
      SET lBounced = 0;
    ELSE
      BEGIN
        SET lBounced = 1;
      END;
  END CASE;

  SET lBounceReasonCode = 0;
  IF lBounced = 1 THEN
    SET lBounceReasonCode = randomRangePicker(0,100);
    CASE
      WHEN lBounceReasonCode <= 5 THEN
        SET lBounceReason = 'other';
      WHEN lBounceReasonCode > 5 AND lBounceReasonCode <= 10 THEN
        SET lBounceReason = 'service';
      WHEN lBounceReasonCode > 10 AND lBounceReasonCode <= 20 THEN
        SET lBounceReason = 'price';
      WHEN lBounceReasonCode > 20 AND lBounceReasonCode <= 30 THEN
        SET lBounceReason = 'terms';
      ELSE
        SET lBounceReason = 'benefits';
    END CASE;
  END IF;

  INSERT INTO `FACT_QUOTES` (
    `age`,
    `creditScore`,
    `dlNumber`,
    `driverName`,
    `numberOfAccidents`,
    `numberOfTickets`,
    `ssn`,
    `policyType`,
    `price`,
    `priceDiscount`,
    `vehicleYear`,
    `processInstanceId`,
    `quote_month`,
    `purchased`,
    `bounced`,
    `bounce_reason`
  ) VALUES (
    lAge,
    randomRangePicker(250, 750),
    CONCAT('DL', randomRangePicker(1000, 10000)),
    CONCAT_WS(' ', 'DRIVER', randomRangePicker(1000, 10000)),
    randomRangePicker(0,4),
    randomRangePicker(0,4),
    randomSSN(),
    'CAR',
    randomRangePicker(150,750),
    randomRangePicker(0,25),
    randomRangePicker(2007, 2017),
    idx,
    randomRangePicker(1,24),
    CASE WHEN lBounced = 0 THEN 1 ELSE 0 END,
    lBounced,
    lBounceReason
  );
END //
DROP PROCEDURE if exists `prc_generate_incidents_mock`;
CREATE PROCEDURE prc_generate_incidents_mock()
BEGIN

  DECLARE lAge INT;
  DECLARE lAgeClassification VARCHAR(5);
  DECLARE lAgeClassificationK INT;

  DECLARE lIncidentCode INT;
  DECLARE lIncidentReason VARCHAR(20);

  SET lAgeClassificationK = randomRangePicker(0, 100);

  -- 15% adults
  -- 40% elder
  -- 55% young
  CASE
    WHEN lAgeClassificationK <= 15 THEN
      SET lAge = randomRangePicker(25, 65);
    WHEN lAgeClassificationK > 15 AND lAgeClassificationK <= 40 THEN
      SET lAge = randomRangePicker(66, 80);
    ELSE
      SET lAge = randomRangePicker(16, 24);
  END CASE;

  SET lAgeClassification = CASE WHEN lAge < 25 THEN 'young' WHEN lAge >= 25 AND lAge < 65 THEN 'adult' ELSE 'elder' END;

  SET lIncidentCode = randomRangePicker(0,100);
  CASE
    WHEN lIncidentCode <= 2 THEN
      SET lIncidentReason = 'other';
    WHEN lIncidentCode > 2 AND lIncidentCode <= 5 THEN
      SET lIncidentReason = 'illness';
    WHEN lIncidentCode > 5 AND lIncidentCode <= 8 THEN
      SET lIncidentReason = 'road visibility';
    WHEN lIncidentCode > 8 AND lIncidentCode <= 13 THEN
      SET lIncidentReason = 'eating';
    WHEN lIncidentCode > 13 AND lIncidentCode <= 15 THEN
      SET lIncidentReason = CASE lAgeClassification WHEN 'elder' THEN 'calling' WHEN 'adult' THEN 'texting' ELSE 'missed signal' END;
    WHEN lIncidentCode > 15 AND lIncidentCode <= 20 THEN
      SET lIncidentReason = 'intoxicated';
    WHEN lIncidentCode > 20 AND lIncidentCode <= 25 THEN
      SET lIncidentReason = CASE lAgeClassification WHEN 'elder' THEN 'texting' WHEN 'adult' THEN 'missed signal' ELSE 'calling' END;
    WHEN lIncidentCode > 25 AND lIncidentCode <= 30 THEN
      SET lIncidentReason = 'chatting';
    WHEN lIncidentCode > 35 AND lIncidentCode <= 40 THEN
      SET lIncidentReason = 'drinking';
    WHEN lIncidentCode > 40 AND lIncidentCode <= 45 THEN
      SET lIncidentReason = 'weather';
    WHEN lIncidentCode > 45 AND lIncidentCode <= 50 THEN
      SET lIncidentReason = 'wrong road signals';
    WHEN lIncidentCode > 50 AND lIncidentCode <= 55 THEN
      SET lIncidentReason = 'mechanical failure';
    ELSE
      SET lIncidentReason = CASE lAgeClassification WHEN 'elder' THEN 'missed signal' WHEN 'adult' THEN 'calling' ELSE 'texting' END;
  END CASE;

  INSERT INTO `FACT_INCIDENTS` (
    `incident_month`,
    `driver_age`,
    `policy_age_months`,
    `incident_reason`,
    `state_id`,
    `driver_age_classification`
  ) VALUES (
    randomRangePicker(1,24),
    lAge,
    randomRangePicker(1,72),
    lIncidentReason,
    randomRangePicker(1,50),
    CASE WHEN lAge < 25 THEN 'young' WHEN lAge >= 25 AND lAge < 65 THEN 'adult' ELSE 'elder' END
  );
END //
DROP PROCEDURE if exists `prc_generate_month_mocks`;
CREATE PROCEDURE prc_generate_month_mocks()
BEGIN
  DECLARE i INT;
  DECLARE lMonth DATE;
  DECLARE lMonthOffset INT;

  DELETE FROM `DIM_MONTHS`
  WHERE `month_id` > 0;
  TRUNCATE `DIM_MONTHS`;

  SET i = 0;

  label_m: LOOP
    SET i = i + 1;
    IF i <= 24 THEN
      SET lMonthOffset = i - 25;
      SET lMonth = DATE_ADD(CURDATE(), INTERVAL lMonthOffset MONTH);
      INSERT INTO `DIM_MONTHS`
      (
        `month_name`,
        `numeric_month`,
        `month`,
        `year`
      ) VALUES (
        CONCAT_WS('-', YEAR(lMonth), MONTHNAME(lMonth)),
        CONCAT_WS('-', YEAR(lMonth), CASE WHEN MONTH(lMonth)<10 THEN CONCAT('0', MONTH(lMonth)) ELSE MONTH(lMonth) END),
        MONTH(lMonth),
        YEAR(lMonth)
      );
      ITERATE label_m;
    END IF;
    LEAVE label_m;
  END LOOP label_m;
END //
DROP PROCEDURE if exists `prc_generate_mocks`;
CREATE PROCEDURE prc_generate_mocks (IN records INT)
BEGIN
  DECLARE i INT;
  DECLARE lAreMonths SMALLINT;

  SELECT COUNT(month_id) INTO lAreMonths FROM `DIM_MONTHS`;
  IF lAreMonths = 0 THEN
    CALL prc_generate_month_mocks();
  END IF;

  SET i = 0;
  label_q: LOOP
    SET i = i + 1;
    IF i <= records THEN
      CALL prc_generate_quote_mock(i);
      CALL prc_generate_incidents_mock();
      ITERATE label_q;
    END IF;
    LEAVE label_q;
  END LOOP label_q;
END //
DELIMITER ;


CALL prc_generate_month_mocks();
CALL prc_generate_mocks(15000);
