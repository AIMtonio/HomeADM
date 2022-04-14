package arrendamiento.bean;

import java.util.List;

import general.bean.BaseBean;

public class CargoAbonoArrendaBean extends BaseBean{

	// ATRIBUTOS DE LA TABLA 
	private String cargoAbonoID;
	private String arrendaID; 
	private String arrendaAmortiID;	
	private String tipoConcepto;
	private String naturaleza;
	private String montoConcepto;	
	private String descriConcepto;
	private String fechaMovimiento;
	private String usuarioMovimiento;
		
	private List<String> arrendaIDCA;
	private List<String> arrendaAmortiIDCA;
	private List<String> tipoConceptoCA;
	private List<String> naturalezaCA;
	private List<String> montoConceptoCA;
	private List<String> descriConceptoCA;
	private List<String> usuarioMovimientoCA;
		
	public String getCargoAbonoID() {
		return cargoAbonoID;
	}
	public void setCargoAbonoID(String cargoAbonoID) {
		this.cargoAbonoID = cargoAbonoID;
	}
	public String getArrendaID() {
		return arrendaID;
	}
	public void setArrendaID(String arrendaID) {
		this.arrendaID = arrendaID;
	}
	public String getArrendaAmortiID() {
		return arrendaAmortiID;
	}
	public void setArrendaAmortiID(String arrendaAmortiID) {
		this.arrendaAmortiID = arrendaAmortiID;
	}
	public String getTipoConcepto() {
		return tipoConcepto;
	}
	public void setTipoConcepto(String tipoConcepto) {
		this.tipoConcepto = tipoConcepto;
	}
	public String getNaturaleza() {
		return naturaleza;
	}
	public void setNaturaleza(String naturaleza) {
		this.naturaleza = naturaleza;
	}
	public String getMontoConcepto() {
		return montoConcepto;
	}
	public void setMontoConcepto(String montoConcepto) {
		this.montoConcepto = montoConcepto;
	}
	public String getDescriConcepto() {
		return descriConcepto;
	}
	public void setDescriConcepto(String descriConcepto) {
		this.descriConcepto = descriConcepto;
	}
	public String getFechaMovimiento() {
		return fechaMovimiento;
	}
	public void setFechaMovimiento(String fechaMovimiento) {
		this.fechaMovimiento = fechaMovimiento;
	}
	public String getUsuarioMovimiento() {
		return usuarioMovimiento;
	}
	public void setUsuarioMovimiento(String usuarioMovimiento) {
		this.usuarioMovimiento = usuarioMovimiento;
	}
	public List<String> getArrendaIDCA() {
		return arrendaIDCA;
	}
	public void setArrendaIDCA(List<String> arrendaIDCA) {
		this.arrendaIDCA = arrendaIDCA;
	}
	public List<String> getArrendaAmortiIDCA() {
		return arrendaAmortiIDCA;
	}
	public void setArrendaAmortiIDCA(List<String> arrendaAmortiIDCA) {
		this.arrendaAmortiIDCA = arrendaAmortiIDCA;
	}
	public List<String> getTipoConceptoCA() {
		return tipoConceptoCA;
	}
	public void setTipoConceptoCA(List<String> tipoConceptoCA) {
		this.tipoConceptoCA = tipoConceptoCA;
	}
	public List<String> getNaturalezaCA() {
		return naturalezaCA;
	}
	public void setNaturalezaCA(List<String> naturalezaCA) {
		this.naturalezaCA = naturalezaCA;
	}
	public List<String> getMontoConceptoCA() {
		return montoConceptoCA;
	}
	public void setMontoConceptoCA(List<String> montoConceptoCA) {
		this.montoConceptoCA = montoConceptoCA;
	}
	public List<String> getDescriConceptoCA() {
		return descriConceptoCA;
	}
	public void setDescriConceptoCA(List<String> descriConceptoCA) {
		this.descriConceptoCA = descriConceptoCA;
	}
	public List<String> getUsuarioMovimientoCA() {
		return usuarioMovimientoCA;
	}
	public void setUsuarioMovimientoCA(List<String> usuarioMovimientoCA) {
		this.usuarioMovimientoCA = usuarioMovimientoCA;
	}
	
}
