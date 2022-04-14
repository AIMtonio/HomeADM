package arrendamiento.bean;

import java.util.List;

import general.bean.BaseBean;

public class ActivoArrendaBean extends BaseBean {
	
	private String arrendaID;
	
	private String activoID;
	private String descripcion;
	private String tipoActivo;
	private String subtipoActivoID;
	private String subtipoActivo;
	private String modelo;
	private String marcaID;
	private String marca;
	private String numeroSerie;
	private String numeroFactura;
	private String valorFactura;
	private String costosAdicionales;
	private String fechaAdquisicion;
	private String vidaUtil;
	private String porcentDepreFis;
	private String porcentDepreAjus;
	private String plazoMaximo;
	private String porcentResidMax;
	private String estatus;
	
	// direccion
	private String estadoID;
	private String estado;
	private String municipioID;
	private String municipio;
	private String localidadID;
	private String localidad;
	private String coloniaID;
	private String colonia;
	private String calle;
	private String numeroCasa;
	private String numeroInterior;
	private String piso;
	private String primerEntrecalle;
	private String segundaEntreCalle;
	private String cp;
	private String direccionCompleta;
	private String latitud;
	private String longitud;
	private String lote;
	private String manzana;
	private String descripcionDom;
	
	// Aseguradora
	private String aseguradoraID;
	private String aseguradora;
	private String estaAsegurado;
	private String numPolizaSeguro;
	private String fechaAdquiSeguro;
	private String inicioCoberSeguro;
	private String finCoberSeguro;
	private String sumaAseguradora;
	private String valorDeduciSeguro;
	private String observaciones;
	
	private List<String> activoIDVin;

	public String getArrendaID() {
		return arrendaID;
	}

	public void setArrendaID(String arrendaID) {
		this.arrendaID = arrendaID;
	}

	public String getActivoID() {
		return activoID;
	}

	public void setActivoID(String activoID) {
		this.activoID = activoID;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getTipoActivo() {
		return tipoActivo;
	}

	public void setTipoActivo(String tipoActivo) {
		this.tipoActivo = tipoActivo;
	}

	public String getSubtipoActivoID() {
		return subtipoActivoID;
	}

	public void setSubtipoActivoID(String subtipoActivoID) {
		this.subtipoActivoID = subtipoActivoID;
	}

	public String getSubtipoActivo() {
		return subtipoActivo;
	}

	public void setSubtipoActivo(String subtipoActivo) {
		this.subtipoActivo = subtipoActivo;
	}

	public String getModelo() {
		return modelo;
	}

	public void setModelo(String modelo) {
		this.modelo = modelo;
	}

	public String getMarcaID() {
		return marcaID;
	}

	public void setMarcaID(String marcaID) {
		this.marcaID = marcaID;
	}

	public String getMarca() {
		return marca;
	}

	public void setMarca(String marca) {
		this.marca = marca;
	}

	public String getNumeroSerie() {
		return numeroSerie;
	}

	public void setNumeroSerie(String numeroSerie) {
		this.numeroSerie = numeroSerie;
	}

	public String getNumeroFactura() {
		return numeroFactura;
	}

	public void setNumeroFactura(String numeroFactura) {
		this.numeroFactura = numeroFactura;
	}

	public String getValorFactura() {
		return valorFactura;
	}

	public void setValorFactura(String valorFactura) {
		this.valorFactura = valorFactura;
	}

	public String getCostosAdicionales() {
		return costosAdicionales;
	}

	public void setCostosAdicionales(String costosAdicionales) {
		this.costosAdicionales = costosAdicionales;
	}

	public String getFechaAdquisicion() {
		return fechaAdquisicion;
	}

	public void setFechaAdquisicion(String fechaAdquisicion) {
		this.fechaAdquisicion = fechaAdquisicion;
	}

	public String getVidaUtil() {
		return vidaUtil;
	}

	public void setVidaUtil(String vidaUtil) {
		this.vidaUtil = vidaUtil;
	}

	public String getPorcentDepreFis() {
		return porcentDepreFis;
	}

	public void setPorcentDepreFis(String porcentDepreFis) {
		this.porcentDepreFis = porcentDepreFis;
	}

	public String getPorcentDepreAjus() {
		return porcentDepreAjus;
	}

	public void setPorcentDepreAjus(String porcentDepreAjus) {
		this.porcentDepreAjus = porcentDepreAjus;
	}

	public String getPlazoMaximo() {
		return plazoMaximo;
	}

	public void setPlazoMaximo(String plazoMaximo) {
		this.plazoMaximo = plazoMaximo;
	}

	public String getPorcentResidMax() {
		return porcentResidMax;
	}

	public void setPorcentResidMax(String porcentResidMax) {
		this.porcentResidMax = porcentResidMax;
	}

	public String getEstatus() {
		return estatus;
	}

	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}

	public String getEstadoID() {
		return estadoID;
	}

	public void setEstadoID(String estadoID) {
		this.estadoID = estadoID;
	}

	public String getEstado() {
		return estado;
	}

	public void setEstado(String estado) {
		this.estado = estado;
	}

	public String getMunicipioID() {
		return municipioID;
	}

	public void setMunicipioID(String municipioID) {
		this.municipioID = municipioID;
	}

	public String getMunicipio() {
		return municipio;
	}

	public void setMunicipio(String municipio) {
		this.municipio = municipio;
	}

	public String getLocalidadID() {
		return localidadID;
	}

	public void setLocalidadID(String localidadID) {
		this.localidadID = localidadID;
	}

	public String getLocalidad() {
		return localidad;
	}

	public void setLocalidad(String localidad) {
		this.localidad = localidad;
	}

	public String getColoniaID() {
		return coloniaID;
	}

	public void setColoniaID(String coloniaID) {
		this.coloniaID = coloniaID;
	}

	public String getColonia() {
		return colonia;
	}

	public void setColonia(String colonia) {
		this.colonia = colonia;
	}

	public String getCalle() {
		return calle;
	}

	public void setCalle(String calle) {
		this.calle = calle;
	}

	public String getNumeroCasa() {
		return numeroCasa;
	}

	public void setNumeroCasa(String numeroCasa) {
		this.numeroCasa = numeroCasa;
	}

	public String getNumeroInterior() {
		return numeroInterior;
	}

	public void setNumeroInterior(String numeroInterior) {
		this.numeroInterior = numeroInterior;
	}

	public String getPiso() {
		return piso;
	}

	public void setPiso(String piso) {
		this.piso = piso;
	}

	public String getPrimerEntrecalle() {
		return primerEntrecalle;
	}

	public void setPrimerEntrecalle(String primerEntrecalle) {
		this.primerEntrecalle = primerEntrecalle;
	}

	public String getSegundaEntreCalle() {
		return segundaEntreCalle;
	}

	public void setSegundaEntreCalle(String segundaEntreCalle) {
		this.segundaEntreCalle = segundaEntreCalle;
	}

	public String getCp() {
		return cp;
	}

	public void setCp(String cp) {
		this.cp = cp;
	}

	public String getDireccionCompleta() {
		return direccionCompleta;
	}

	public void setDireccionCompleta(String direccionCompleta) {
		this.direccionCompleta = direccionCompleta;
	}

	public String getLatitud() {
		return latitud;
	}

	public void setLatitud(String latitud) {
		this.latitud = latitud;
	}

	public String getLongitud() {
		return longitud;
	}

	public void setLongitud(String longitud) {
		this.longitud = longitud;
	}

	public String getLote() {
		return lote;
	}

	public void setLote(String lote) {
		this.lote = lote;
	}

	public String getManzana() {
		return manzana;
	}

	public void setManzana(String manzana) {
		this.manzana = manzana;
	}

	public String getDescripcionDom() {
		return descripcionDom;
	}

	public void setDescripcionDom(String descripcionDom) {
		this.descripcionDom = descripcionDom;
	}

	public String getAseguradoraID() {
		return aseguradoraID;
	}

	public void setAseguradoraID(String aseguradoraID) {
		this.aseguradoraID = aseguradoraID;
	}

	public String getAseguradora() {
		return aseguradora;
	}

	public void setAseguradora(String aseguradora) {
		this.aseguradora = aseguradora;
	}

	public String getEstaAsegurado() {
		return estaAsegurado;
	}

	public void setEstaAsegurado(String estaAsegurado) {
		this.estaAsegurado = estaAsegurado;
	}

	public String getNumPolizaSeguro() {
		return numPolizaSeguro;
	}

	public void setNumPolizaSeguro(String numPolizaSeguro) {
		this.numPolizaSeguro = numPolizaSeguro;
	}

	public String getFechaAdquiSeguro() {
		return fechaAdquiSeguro;
	}

	public void setFechaAdquiSeguro(String fechaAdquiSeguro) {
		this.fechaAdquiSeguro = fechaAdquiSeguro;
	}

	public String getInicioCoberSeguro() {
		return inicioCoberSeguro;
	}

	public void setInicioCoberSeguro(String inicioCoberSeguro) {
		this.inicioCoberSeguro = inicioCoberSeguro;
	}

	public String getFinCoberSeguro() {
		return finCoberSeguro;
	}

	public void setFinCoberSeguro(String finCoberSeguro) {
		this.finCoberSeguro = finCoberSeguro;
	}

	public String getSumaAseguradora() {
		return sumaAseguradora;
	}

	public void setSumaAseguradora(String sumaAseguradora) {
		this.sumaAseguradora = sumaAseguradora;
	}

	public String getValorDeduciSeguro() {
		return valorDeduciSeguro;
	}

	public void setValorDeduciSeguro(String valorDeduciSeguro) {
		this.valorDeduciSeguro = valorDeduciSeguro;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

	public List<String> getActivoIDVin() {
		return activoIDVin;
	}

	public void setActivoIDVin(List<String> activoIDVin) {
		this.activoIDVin = activoIDVin;
	}
}
