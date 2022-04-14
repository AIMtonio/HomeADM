package originacion.bean;

import general.bean.BaseBean; 

public class SocDemogViviendaBean extends BaseBean {
	
	private String prospectoID;
	private String clienteID;
	private String fechaRegistro;
	private String tipoViviendaID;
	private String conDrenaje;
	private String conElectricidad;
	private String conAgua;
	private String conGas;
	private String conPavimento;
	private String tipoMaterialID;
	private String valorVivienda;
	private String descripcion;
	private String tiempoHabitarDom;
	
	//para combo material vivienda
	private String descripMaterial;
	
	//para combo tipo vivienda
	private String descripVivienda;
	
	public String getDescripVivienda() {
		return descripVivienda;
	}
	public void setDescripVivienda(String descripVivienda) {
		this.descripVivienda = descripVivienda;
	}
	public String getDescripMaterial() {
		return descripMaterial;
	}
	public void setDescripMaterial(String descripMaterial) {
		this.descripMaterial = descripMaterial;
	}
	public String getProspectoID() {
		return prospectoID;
	}
	public void setProspectoID(String prospectoID) {
		this.prospectoID = prospectoID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getFechaRegistro() {
		return fechaRegistro;
	}
	public void setFechaRegistro(String fechaRegistro) {
		this.fechaRegistro = fechaRegistro;
	}
	public String getTipoViviendaID() {
		return tipoViviendaID;
	}
	public void setTipoViviendaID(String tipoViviendaID) {
		this.tipoViviendaID = tipoViviendaID;
	}
	public String getConDrenaje() {
		return conDrenaje;
	}
	public void setConDrenaje(String conDrenaje) {
		this.conDrenaje = conDrenaje;
	}
	public String getConElectricidad() {
		return conElectricidad;
	}
	public void setConElectricidad(String conElectricidad) {
		this.conElectricidad = conElectricidad;
	}
	public String getConAgua() {
		return conAgua;
	}
	public void setConAgua(String conAgua) {
		this.conAgua = conAgua;
	}
	public String getConGas() {
		return conGas;
	}
	public void setConGas(String conGas) {
		this.conGas = conGas;
	}
	public String getConPavimento() {
		return conPavimento;
	}
	public void setConPavimento(String conPavimento) {
		this.conPavimento = conPavimento;
	}
	public String getTipoMaterialID() {
		return tipoMaterialID;
	}
	public void setTipoMaterialID(String tipoMaterialID) {
		this.tipoMaterialID = tipoMaterialID;
	}
	public String getValorVivienda() {
		return valorVivienda;
	}
	public void setValorVivienda(String valorVivienda) {
		this.valorVivienda = valorVivienda;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getTiempoHabitarDom() {
		return tiempoHabitarDom;
	}
	public void setTiempoHabitarDom(String tiempoHabitarDom) {
		this.tiempoHabitarDom = tiempoHabitarDom;
	}


}
