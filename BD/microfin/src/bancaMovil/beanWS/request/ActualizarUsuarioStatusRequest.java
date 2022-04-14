package bancaMovil.beanWS.request;

import soporte.consumo.rest.BaseBeanRequest;

public class ActualizarUsuarioStatusRequest extends BaseBeanRequest {

	private String customerNumber;
	private String typeOperation;
	private String reason;

	public String getCustomerNumber() {
		return customerNumber;
	}

	public void setCustomerNumber(String customerNumber) {
		this.customerNumber = customerNumber;
	}

	public String getTypeOperation() {
		return typeOperation;
	}

	public void setTypeOperation(String typeOperation) {
		this.typeOperation = typeOperation;
	}

	public String getReason() {
		return reason;
	}

	public void setReason(String reason) {
		this.reason = reason;
	}
}
