package tesoreria.bean;

import java.util.List;

import general.bean.BaseBean;

public class MovNoIdentificadosBean extends BaseBean{
	
	public String institucionID;
	public String numCtaInstit;
	public String cuentaAhoID;
	public String fechaMov;
		
	public List<String> consecutivoID;
	public List<String> descripcion;
	public List<String> fechaOperacion;
	public List<String> natMovimiento;
	public List<String> monto;
	public List<String> referencia;
	
	public String getInstitucionID() {
		return institucionID;
	}
	public void setInstitucionID(String institucionID) {
		this.institucionID = institucionID;
	}
	public String getNumCtaInstit() {
		return numCtaInstit;
	}
	public void setNumCtaInstit(String numCtaInstit) {
		this.numCtaInstit = numCtaInstit;
	}
	public String getCuentaAhoID() {
		return cuentaAhoID;
	}
	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}
	public String getFechaMov() {
		return fechaMov;
	}
	public void setFechaMov(String fechaMov) {
		this.fechaMov = fechaMov;
	}
	public List<String> getConsecutivoID() {
		return consecutivoID;
	}
	public void setConsecutivoID(List<String> consecutivoID) {
		this.consecutivoID = consecutivoID;
	}
	public List<String> getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(List<String> descripcion) {
		this.descripcion = descripcion;
	}
	public List<String> getFechaOperacion() {
		return fechaOperacion;
	}
	public void setFechaOperacion(List<String> fechaOperacion) {
		this.fechaOperacion = fechaOperacion;
	}
	public List<String> getNatMovimiento() {
		return natMovimiento;
	}
	public void setNatMovimiento(List<String> natMovimiento) {
		this.natMovimiento = natMovimiento;
	}
	public List<String> getMonto() {
		return monto;
	}
	public void setMonto(List<String> monto) {
		this.monto = monto;
	}
	public List<String> getReferencia() {
		return referencia;
	}
	public void setReferencia(List<String> referencia) {
		this.referencia = referencia;
	}
}
