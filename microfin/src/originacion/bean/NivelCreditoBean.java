package originacion.bean;

import general.bean.BaseBean;
import java.util.List;

public class NivelCreditoBean extends BaseBean{
	private String nivelID;
	private String descripcion;
	private String numVecesAsignado;
	private String tasaNivel;
	
	private List lisNivelID;
	private List lisDescripcion;
	
	private String sucursal;
	private String productoCreditoID;
	private String numCreditos;
	private String montoCredito;
	private String calificaCliente;
	private String plazoID;
	private String empresaNomina;
	
	public String getNivelID() {
		return nivelID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public List getLisNivelID() {
		return lisNivelID;
	}
	public List getLisDescripcion() {
		return lisDescripcion;
	}
	public void setNivelID(String nivelID) {
		this.nivelID = nivelID;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public void setLisNivelID(List lisNivelID) {
		this.lisNivelID = lisNivelID;
	}
	public void setLisDescripcion(List lisDescripcion) {
		this.lisDescripcion = lisDescripcion;
	}
	public String getNumVecesAsignado() {
		return numVecesAsignado;
	}
	public void setNumVecesAsignado(String numVecesAsignado) {
		this.numVecesAsignado = numVecesAsignado;
	}
	public String getTasaNivel() {
		return tasaNivel;
	}
	public void setTasaNivel(String tasaNivel) {
		this.tasaNivel = tasaNivel;
	}
	public String getSucursal() {
		return sucursal;
	}
	public String getProductoCreditoID() {
		return productoCreditoID;
	}
	public String getNumCreditos() {
		return numCreditos;
	}
	public String getMontoCredito() {
		return montoCredito;
	}
	public String getCalificaCliente() {
		return calificaCliente;
	}
	public String getPlazoID() {
		return plazoID;
	}
	public String getEmpresaNomina() {
		return empresaNomina;
	}
	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
	}
	public void setProductoCreditoID(String productoCreditoID) {
		this.productoCreditoID = productoCreditoID;
	}
	public void setNumCreditos(String numCreditos) {
		this.numCreditos = numCreditos;
	}
	public void setMontoCredito(String montoCredito) {
		this.montoCredito = montoCredito;
	}
	public void setCalificaCliente(String calificaCliente) {
		this.calificaCliente = calificaCliente;
	}
	public void setPlazoID(String plazoID) {
		this.plazoID = plazoID;
	}
	public void setEmpresaNomina(String empresaNomina) {
		this.empresaNomina = empresaNomina;
	}
}
