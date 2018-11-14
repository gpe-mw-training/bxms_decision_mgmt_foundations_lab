package com.myteam.policy_quote;

import java.io.Serializable;
import java.util.Date;

public class Policy implements Serializable {

	private static final long serialVersionUID = 1L;

	private Date requestDate;
	private String policyType;
	private Integer vehicleYear;
	private Integer price = 0;
	private Integer priceDiscount = 0;
	private String driver;

	@org.kie.api.definition.type.Label("Vehicle Plates")
	private java.lang.String plates;

	@org.kie.api.definition.type.Label("Plates State Code")
	private java.lang.String platesStateCode;

	private java.lang.Integer priceSurcharge = 0;

	private java.lang.String rejectReason;

	public String toString() {
		StringBuilder sBuilder = new StringBuilder();
		sBuilder.append("\nPolicy \n\tpolicyType = ");
		sBuilder.append(this.policyType);
		sBuilder.append("\n\tvehicleYear = ");
		sBuilder.append(this.vehicleYear);
		sBuilder.append("\n\tprice = ");
		sBuilder.append(this.price);
		sBuilder.append("\n\tpriceDiscount = ");
		sBuilder.append(this.priceDiscount);
		sBuilder.append("\n\tDriver = ");
		sBuilder.append(this.driver);
		sBuilder.append("\n\tPlates = ");
		sBuilder.append(this.plates);
		sBuilder.append("\n\tPlates State = ");
		sBuilder.append(this.platesStateCode);
		return sBuilder.toString();
	}

	public Date getRequestDate() {
		return this.requestDate;
	}

	public void setRequestDate(Date requestDate) {
		this.requestDate = requestDate;
	}

	public String getPolicyType() {
		return this.policyType;
	}

	public void setPolicyType(String policyType) {
		this.policyType = policyType;
	}

	public Integer getVehicleYear() {
		return this.vehicleYear;
	}

	public void setVehicleYear(Integer vehicleYear) {
		this.vehicleYear = vehicleYear;
	}

	public Integer getPrice() {
		return this.price;
	}

	public void setPrice(Integer price) {
		this.price = price;
	}

	public Integer getPriceDiscount() {
		return this.priceDiscount;
	}

	public void setPriceDiscount(Integer discount) {
		this.priceDiscount = discount;
	}

	public String getDriver() {
		return this.driver;
	}

	public void setDriver(String driver) {
		this.driver = driver;
	}

	public java.lang.String getPlates() {
		return this.plates;
	}

	public void setPlates(java.lang.String plates) {
		this.plates = plates;
	}

	public java.lang.String getPlatesStateCode() {
		return this.platesStateCode;
	}

	public void setPlatesStateCode(java.lang.String platesStateCode) {
		this.platesStateCode = platesStateCode;
	}

	public Policy() {
	}

	public java.lang.Integer getPriceSurcharge() {
		return this.priceSurcharge;
	}

	public void setPriceSurcharge(java.lang.Integer priceSurcharge) {
		this.priceSurcharge = priceSurcharge;
	}

	public java.lang.String getRejectReason() {
		return this.rejectReason;
	}

	public void setRejectReason(java.lang.String rejectReason) {
		this.rejectReason = rejectReason;
	}

	public Policy(java.util.Date requestDate, java.lang.String policyType,
			java.lang.Integer vehicleYear, java.lang.Integer price,
			java.lang.Integer priceDiscount, java.lang.String driver,
			java.lang.String plates, java.lang.String platesStateCode,
			java.lang.Integer priceSurcharge, java.lang.String rejectReason) {
		this.requestDate = requestDate;
		this.policyType = policyType;
		this.vehicleYear = vehicleYear;
		this.price = price;
		this.priceDiscount = priceDiscount;
		this.driver = driver;
		this.plates = plates;
		this.platesStateCode = platesStateCode;
		this.priceSurcharge = priceSurcharge;
		this.rejectReason = rejectReason;
	}

}
