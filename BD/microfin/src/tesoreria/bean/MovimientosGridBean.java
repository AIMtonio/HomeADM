package tesoreria.bean;

import java.util.List;

public class MovimientosGridBean {
	// se utiliza para la conciliacion de Movimientos.
	
	private String institucionID;
	private String numCtaInstit;
	
	//variables de la tabla TesoreriaMovs (Internos)
	private String folioMovimiento; 
	private String numeroMov; 
	private String fechaMov; 
	private String descripcionMov; 
	private String tipoMov; 
	private String montoMov;
	private String status;
	private String referenciaMov; 
	private String natMovimiento;
	
	//variables de la tabla TesomovsConcilia (externos)
	private String folioCargaIDArch; 
	private String numeroMovArch;
	private String fechaOperacionArch; 
	private String descripcionMovArch; 
	private String referenciaMovArch; 
	private String tipoMovArch;
	private String montoMovArch;
	private String natMovimientoArch;
	
	public String getFolioMovimiento() {
		return folioMovimiento;
	}
	public void setFolioMovimiento(String folioMovimiento) {
		this.folioMovimiento = folioMovimiento;
	}
	public String getNumeroMov() {
		return numeroMov;
	}
	public void setNumeroMov(String numeroMov) {
		this.numeroMov = numeroMov;
	}
	public String getFechaMov() {
		return fechaMov;
	}
	public void setFechaMov(String fechaMov) {
		this.fechaMov = fechaMov;
	}
	public String getDescripcionMov() {
		return descripcionMov;
	}
	public void setDescripcionMov(String descripcionMov) {
		this.descripcionMov = descripcionMov;
	}
	public String getTipoMov() {
		return tipoMov;
	}
	public void setTipoMov(String tipoMov) {
		this.tipoMov = tipoMov;
	}
	public String getMontoMov() {
		return montoMov;
	}
	public void setMontoMov(String montoMov) {
		this.montoMov = montoMov;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getReferenciaMov() {
		return referenciaMov;
	}
	public void setReferenciaMov(String referenciaMov) {
		this.referenciaMov = referenciaMov;
	}
	public String getFolioCargaIDArch() {
		return folioCargaIDArch;
	}
	public void setFolioCargaIDArch(String folioCargaIDArch) {
		this.folioCargaIDArch = folioCargaIDArch;
	}
	public String getNumeroMovArch() {
		return numeroMovArch;
	}
	public void setNumeroMovArch(String numeroMovArch) {
		this.numeroMovArch = numeroMovArch;
	}
	public String getFechaOperacionArch() {
		return fechaOperacionArch;
	}
	public void setFechaOperacionArch(String fechaOperacionArch) {
		this.fechaOperacionArch = fechaOperacionArch;
	}
	public String getDescripcionMovArch() {
		return descripcionMovArch;
	}
	public void setDescripcionMovArch(String descripcionMovArch) {
		this.descripcionMovArch = descripcionMovArch;
	}
	public String getReferenciaMovArch() {
		return referenciaMovArch;
	}
	public void setReferenciaMovArch(String referenciaMovArch) {
		this.referenciaMovArch = referenciaMovArch;
	}
	public String getTipoMovArch() {
		return tipoMovArch;
	}
	public void setTipoMovArch(String tipoMovArch) {
		this.tipoMovArch = tipoMovArch;
	}
	public String getMontoMovArch() {
		return montoMovArch;
	}
	public void setMontoMovArch(String montoMovArch) {
		this.montoMovArch = montoMovArch;
	}
	public String getNatMovimiento() {
		return natMovimiento;
	}
	public void setNatMovimiento(String natMovimiento) {
		this.natMovimiento = natMovimiento;
	}
	public String getNatMovimientoArch() {
		return natMovimientoArch;
	}
	public void setNatMovimientoArch(String natMovimientoArch) {
		this.natMovimientoArch = natMovimientoArch;
	}
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
}
