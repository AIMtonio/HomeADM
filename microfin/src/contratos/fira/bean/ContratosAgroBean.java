package contratos.fira.bean;

public class ContratosAgroBean {
	
	// Generales del contrato
	private String grupoID;
	private String montoTotal;
	private String porcBonif;
	private String montoBonif;
	private String plazo;
	private String tasaOrdinaria;
	private String tasaMoratoria;
	private String CAT;
	private String comisionAdmon;
	private String montoComAdm;
	private String coberturaSeguro;
	private String primaSeguro;
	private String datosUEAU;
	private String porcGarLiquida;
	private String montoGarLiquida;
	private String reca;
	private String direccionSuc;
	private String fechaNacRepLegal;
	private String direcRepLegal;
	private String identRepLegal;
	private String fechaIniCredito;
	private String direccionPresidenta;
	private String creditoID;
	private String nombreProd;
	private String montoDeuda;
	private String montoTotConcepInv;
	private String recursoPrestConInv;
	private String recursoSoliConInv;
	private String otrosRecConInv;
	private String proporcionGar;
	private String proporcionLetra;
	private String solicitudCreditoID;
	private String clienteID;
	private String direccionCliente;
	private String nombreCliente;
	private String vigenciaLetra;	
	private String tipoGarantia;
	private String observaciones;
	private String nomApoderadoLegal;
	private String numEscPub;
	private String fechaEscPub;
	private String numNotariaPub;
	private String nomMunicipioEscPub;
	private String nomEstadoEscPub;
	private String folioMercantil;
	private String nombreNotario;
	private String nomRepresentanteLeg;
	private String aliasCliente;
	private String cadenaAvales;
	private String cadenaGarantes;
	private String frecuencia;
	private String destinoCredito;
	private String montoLetra;
	private String nombre;
	private String rfc;
	private String domicilio;
	private String identificacion;
	private String cargoApoLegal;
	private String escPublicPM;
	private String fechaEscPM;
	private String notariaPM;
	private String nombreNotarioPM;
	private String municipioNotariaPM;
	private String estadoNotariaPM;
	private String direccionNotariaPM;
	private String folioMercantilPM;
	private String tipoSociedad;
	
	// Directivos
	private String directivoID;
	private String cargoID;
	private String nombreCargo;
	private String direccion;
	private String personaID;
	private String tipoDirectivo;
	private String nombreCompleto;
	private String alias;
	
	// PorcentajesGarantiaFIRA
	private String tipoGarantiaID;
	private String clasificacionID;
	private String porcentaje;
	
	// Calendario de ministraciones
	private String numeroMinistracion;
	private String fechaMinistracion;
	private String capitalMinistracion;
	
	// Garantias y garante
	private String garantiaID;
	private String garObservaciones;
	private String garFigura;
	private String garanteID;
	private String garTipoPersona;
	private String garNombreGarante;
	private String garAlias;
	private String garUsufructuaria;
	private String garTipoGarantia;
	
	public String getGrupoID() {
		return grupoID;
	}
	public void setGrupoID(String grupoID) {
		this.grupoID = grupoID;
	}
	public String getMontoTotal() {
		return montoTotal;
	}
	public void setMontoTotal(String montoTotal) {
		this.montoTotal = montoTotal;
	}
	public String getPorcBonif() {
		return porcBonif;
	}
	public void setPorcBonif(String porcBonif) {
		this.porcBonif = porcBonif;
	}
	public String getMontoBonif() {
		return montoBonif;
	}
	public void setMontoBonif(String montoBonif) {
		this.montoBonif = montoBonif;
	}
	public String getPlazo() {
		return plazo;
	}
	public void setPlazo(String plazo) {
		this.plazo = plazo;
	}
	public String getTasaOrdinaria() {
		return tasaOrdinaria;
	}
	public void setTasaOrdinaria(String tasaOrdinaria) {
		this.tasaOrdinaria = tasaOrdinaria;
	}
	public String getTasaMoratoria() {
		return tasaMoratoria;
	}
	public void setTasaMoratoria(String tasaMoratoria) {
		this.tasaMoratoria = tasaMoratoria;
	}
	public String getCAT() {
		return CAT;
	}
	public void setCAT(String cAT) {
		CAT = cAT;
	}
	public String getComisionAdmon() {
		return comisionAdmon;
	}
	public void setComisionAdmon(String comisionAdmon) {
		this.comisionAdmon = comisionAdmon;
	}
	public String getMontoComAdm() {
		return montoComAdm;
	}
	public void setMontoComAdm(String montoComAdm) {
		this.montoComAdm = montoComAdm;
	}
	public String getCoberturaSeguro() {
		return coberturaSeguro;
	}
	public void setCoberturaSeguro(String coberturaSeguro) {
		this.coberturaSeguro = coberturaSeguro;
	}
	public String getPrimaSeguro() {
		return primaSeguro;
	}
	public void setPrimaSeguro(String primaSeguro) {
		this.primaSeguro = primaSeguro;
	}
	public String getDatosUEAU() {
		return datosUEAU;
	}
	public void setDatosUEAU(String datosUEAU) {
		this.datosUEAU = datosUEAU;
	}
	public String getPorcGarLiquida() {
		return porcGarLiquida;
	}
	public void setPorcGarLiquida(String porcGarLiquida) {
		this.porcGarLiquida = porcGarLiquida;
	}
	public String getMontoGarLiquida() {
		return montoGarLiquida;
	}
	public void setMontoGarLiquida(String montoGarLiquida) {
		this.montoGarLiquida = montoGarLiquida;
	}
	public String getReca() {
		return reca;
	}
	public void setReca(String reca) {
		this.reca = reca;
	}
	public String getDireccionSuc() {
		return direccionSuc;
	}
	public void setDireccionSuc(String direccionSuc) {
		this.direccionSuc = direccionSuc;
	}
	public String getFechaNacRepLegal() {
		return fechaNacRepLegal;
	}
	public void setFechaNacRepLegal(String fechaNacRepLegal) {
		this.fechaNacRepLegal = fechaNacRepLegal;
	}
	public String getDirecRepLegal() {
		return direcRepLegal;
	}
	public void setDirecRepLegal(String direcRepLegal) {
		this.direcRepLegal = direcRepLegal;
	}
	public String getIdentRepLegal() {
		return identRepLegal;
	}
	public void setIdentRepLegal(String identRepLegal) {
		this.identRepLegal = identRepLegal;
	}
	public String getFechaIniCredito() {
		return fechaIniCredito;
	}
	public void setFechaIniCredito(String fechaIniCredito) {
		this.fechaIniCredito = fechaIniCredito;
	}
	public String getDireccionPresidenta() {
		return direccionPresidenta;
	}
	public void setDireccionPresidenta(String direccionPresidenta) {
		this.direccionPresidenta = direccionPresidenta;
	}
	public String getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public String getNombreProd() {
		return nombreProd;
	}
	public void setNombreProd(String nombreProd) {
		this.nombreProd = nombreProd;
	}
	public String getMontoDeuda() {
		return montoDeuda;
	}
	public void setMontoDeuda(String montoDeuda) {
		this.montoDeuda = montoDeuda;
	}
	public String getMontoTotConcepInv() {
		return montoTotConcepInv;
	}
	public void setMontoTotConcepInv(String montoTotConcepInv) {
		this.montoTotConcepInv = montoTotConcepInv;
	}
	public String getRecursoPrestConInv() {
		return recursoPrestConInv;
	}
	public void setRecursoPrestConInv(String recursoPrestConInv) {
		this.recursoPrestConInv = recursoPrestConInv;
	}
	public String getRecursoSoliConInv() {
		return recursoSoliConInv;
	}
	public void setRecursoSoliConInv(String recursoSoliConInv) {
		this.recursoSoliConInv = recursoSoliConInv;
	}
	public String getOtrosRecConInv() {
		return otrosRecConInv;
	}
	public void setOtrosRecConInv(String otrosRecConInv) {
		this.otrosRecConInv = otrosRecConInv;
	}
	public String getProporcionGar() {
		return proporcionGar;
	}
	public void setProporcionGar(String proporcionGar) {
		this.proporcionGar = proporcionGar;
	}
	public String getProporcionLetra() {
		return proporcionLetra;
	}
	public void setProporcionLetra(String proporcionLetra) {
		this.proporcionLetra = proporcionLetra;
	}
	public String getSolicitudCreditoID() {
		return solicitudCreditoID;
	}
	public void setSolicitudCreditoID(String solicitudCreditoID) {
		this.solicitudCreditoID = solicitudCreditoID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getDireccionCliente() {
		return direccionCliente;
	}
	public void setDireccionCliente(String direccionCliente) {
		this.direccionCliente = direccionCliente;
	}
	public String getNombreCliente() {
		return nombreCliente;
	}
	public void setNombreCliente(String nombreCliente) {
		this.nombreCliente = nombreCliente;
	}
	public String getVigenciaLetra() {
		return vigenciaLetra;
	}
	public void setVigenciaLetra(String vigenciaLetra) {
		this.vigenciaLetra = vigenciaLetra;
	}
	public String getTipoGarantia() {
		return tipoGarantia;
	}
	public void setTipoGarantia(String tipoGarantia) {
		this.tipoGarantia = tipoGarantia;
	}
	public String getObservaciones() {
		return observaciones;
	}
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	public String getNomApoderadoLegal() {
		return nomApoderadoLegal;
	}
	public void setNomApoderadoLegal(String nomApoderadoLegal) {
		this.nomApoderadoLegal = nomApoderadoLegal;
	}
	public String getNumEscPub() {
		return numEscPub;
	}
	public void setNumEscPub(String numEscPub) {
		this.numEscPub = numEscPub;
	}
	public String getFechaEscPub() {
		return fechaEscPub;
	}
	public void setFechaEscPub(String fechaEscPub) {
		this.fechaEscPub = fechaEscPub;
	}
	public String getNumNotariaPub() {
		return numNotariaPub;
	}
	public void setNumNotariaPub(String numNotariaPub) {
		this.numNotariaPub = numNotariaPub;
	}
	public String getNomMunicipioEscPub() {
		return nomMunicipioEscPub;
	}
	public void setNomMunicipioEscPub(String nomMunicipioEscPub) {
		this.nomMunicipioEscPub = nomMunicipioEscPub;
	}
	public String getNomEstadoEscPub() {
		return nomEstadoEscPub;
	}
	public void setNomEstadoEscPub(String nomEstadoEscPub) {
		this.nomEstadoEscPub = nomEstadoEscPub;
	}
	public String getFolioMercantil() {
		return folioMercantil;
	}
	public void setFolioMercantil(String folioMercantil) {
		this.folioMercantil = folioMercantil;
	}
	public String getNombreNotario() {
		return nombreNotario;
	}
	public void setNombreNotario(String nombreNotario) {
		this.nombreNotario = nombreNotario;
	}
	public String getNomRepresentanteLeg() {
		return nomRepresentanteLeg;
	}
	public void setNomRepresentanteLeg(String nomRepresentanteLeg) {
		this.nomRepresentanteLeg = nomRepresentanteLeg;
	}
	public String getAliasCliente() {
		return aliasCliente;
	}
	public void setAliasCliente(String aliasCliente) {
		this.aliasCliente = aliasCliente;
	}
	public String getCadenaAvales() {
		return cadenaAvales;
	}
	public void setCadenaAvales(String cadenaAvales) {
		this.cadenaAvales = cadenaAvales;
	}
	public String getCadenaGarantes() {
		return cadenaGarantes;
	}
	public void setCadenaGarantes(String cadenaGarantes) {
		this.cadenaGarantes = cadenaGarantes;
	}
	public String getFrecuencia() {
		return frecuencia;
	}
	public void setFrecuencia(String frecuencia) {
		this.frecuencia = frecuencia;
	}
	public String getDestinoCredito() {
		return destinoCredito;
	}
	public void setDestinoCredito(String destinoCredito) {
		this.destinoCredito = destinoCredito;
	}
	public String getMontoLetra() {
		return montoLetra;
	}
	public void setMontoLetra(String montoLetra) {
		this.montoLetra = montoLetra;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getRfc() {
		return rfc;
	}
	public void setRfc(String rfc) {
		this.rfc = rfc;
	}
	public String getDomicilio() {
		return domicilio;
	}
	public void setDomicilio(String domicilio) {
		this.domicilio = domicilio;
	}
	public String getIdentificacion() {
		return identificacion;
	}
	public void setIdentificacion(String identificacion) {
		this.identificacion = identificacion;
	}
	public String getTipoGarantiaID() {
		return tipoGarantiaID;
	}
	public void setTipoGarantiaID(String tipoGarantiaID) {
		this.tipoGarantiaID = tipoGarantiaID;
	}
	public String getClasificacionID() {
		return clasificacionID;
	}
	public void setClasificacionID(String clasificacionID) {
		this.clasificacionID = clasificacionID;
	}
	public String getPorcentaje() {
		return porcentaje;
	}
	public void setPorcentaje(String porcentaje) {
		this.porcentaje = porcentaje;
	}
	public String getNumeroMinistracion() {
		return numeroMinistracion;
	}
	public void setNumeroMinistracion(String numeroMinistracion) {
		this.numeroMinistracion = numeroMinistracion;
	}
	public String getFechaMinistracion() {
		return fechaMinistracion;
	}
	public void setFechaMinistracion(String fechaMinistracion) {
		this.fechaMinistracion = fechaMinistracion;
	}
	public String getCapitalMinistracion() {
		return capitalMinistracion;
	}
	public void setCapitalMinistracion(String capitalMinistracion) {
		this.capitalMinistracion = capitalMinistracion;
	}
	public String getGarantiaID() {
		return garantiaID;
	}
	public void setGarantiaID(String garantiaID) {
		this.garantiaID = garantiaID;
	}
	public String getGarObservaciones() {
		return garObservaciones;
	}
	public void setGarObservaciones(String garObservaciones) {
		this.garObservaciones = garObservaciones;
	}
	public String getGarFigura() {
		return garFigura;
	}
	public void setGarFigura(String garFigura) {
		this.garFigura = garFigura;
	}
	public String getGaranteID() {
		return garanteID;
	}
	public void setGaranteID(String garanteID) {
		this.garanteID = garanteID;
	}
	public String getGarTipoPersona() {
		return garTipoPersona;
	}
	public void setGarTipoPersona(String garTipoPersona) {
		this.garTipoPersona = garTipoPersona;
	}
	public String getGarNombreGarante() {
		return garNombreGarante;
	}
	public void setGarNombreGarante(String garNombreGarante) {
		this.garNombreGarante = garNombreGarante;
	}
	public String getGarAlias() {
		return garAlias;
	}
	public void setGarAlias(String garAlias) {
		this.garAlias = garAlias;
	}
	public String getGarUsufructuaria() {
		return garUsufructuaria;
	}
	public void setGarUsufructuaria(String garUsufructuaria) {
		this.garUsufructuaria = garUsufructuaria;
	}
	public String getGarTipoGarantia() {
		return garTipoGarantia;
	}
	public void setGarTipoGarantia(String garTipoGarantia) {
		this.garTipoGarantia = garTipoGarantia;
	}
	public String getCargoApoLegal() {
		return cargoApoLegal;
	}
	public void setCargoApoLegal(String cargoApoLegal) {
		this.cargoApoLegal = cargoApoLegal;
	}
	public String getDirectivoID() {
		return directivoID;
	}
	public void setDirectivoID(String directivoID) {
		this.directivoID = directivoID;
	}
	public String getCargoID() {
		return cargoID;
	}
	public void setCargoID(String cargoID) {
		this.cargoID = cargoID;
	}
	public String getNombreCargo() {
		return nombreCargo;
	}
	public void setNombreCargo(String nombreCargo) {
		this.nombreCargo = nombreCargo;
	}
	public String getDireccion() {
		return direccion;
	}
	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}
	public String getPersonaID() {
		return personaID;
	}
	public void setPersonaID(String personaID) {
		this.personaID = personaID;
	}
	public String getTipoDirectivo() {
		return tipoDirectivo;
	}
	public void setTipoDirectivo(String tipoDirectivo) {
		this.tipoDirectivo = tipoDirectivo;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public String getAlias() {
		return alias;
	}
	public void setAlias(String alias) {
		this.alias = alias;
	}
	public String getEscPublicPM() {
		return escPublicPM;
	}
	public void setEscPublicPM(String escPublicPM) {
		this.escPublicPM = escPublicPM;
	}
	public String getFechaEscPM() {
		return fechaEscPM;
	}
	public void setFechaEscPM(String fechaEscPM) {
		this.fechaEscPM = fechaEscPM;
	}
	public String getNotariaPM() {
		return notariaPM;
	}
	public void setNotariaPM(String notariaPM) {
		this.notariaPM = notariaPM;
	}
	public String getNombreNotarioPM() {
		return nombreNotarioPM;
	}
	public void setNombreNotarioPM(String nombreNotarioPM) {
		this.nombreNotarioPM = nombreNotarioPM;
	}
	public String getMunicipioNotariaPM() {
		return municipioNotariaPM;
	}
	public void setMunicipioNotariaPM(String municipioNotariaPM) {
		this.municipioNotariaPM = municipioNotariaPM;
	}
	public String getEstadoNotariaPM() {
		return estadoNotariaPM;
	}
	public void setEstadoNotariaPM(String estadoNotariaPM) {
		this.estadoNotariaPM = estadoNotariaPM;
	}
	public String getDireccionNotariaPM() {
		return direccionNotariaPM;
	}
	public void setDireccionNotariaPM(String direccionNotariaPM) {
		this.direccionNotariaPM = direccionNotariaPM;
	}
	public String getFolioMercantilPM() {
		return folioMercantilPM;
	}
	public void setFolioMercantilPM(String folioMercantilPM) {
		this.folioMercantilPM = folioMercantilPM;
	}
	public String getTipoSociedad() {
		return tipoSociedad;
	}
	public void setTipoSociedad(String tipoSociedad) {
		this.tipoSociedad = tipoSociedad;
	}
	
}