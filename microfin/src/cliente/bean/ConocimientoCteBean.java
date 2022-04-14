package cliente.bean;

import general.bean.BaseBean;

public class ConocimientoCteBean extends BaseBean{

	private String clienteID;
	private String nomGrupo;
	private String RFC;
	private String participacion;
	private String nacionalidad;
	private String razonSocial;
	private String giro;
	private String PEPs;
	private String funcionID;
	private String parentescoPEP;
	private String nombFamiliar;
	private String aPaternoFam;
	private String aMaternoFam;
	private String noEmpleados;
	private String serv_Produc;
	private String cober_Geograf;
	private String estados_Presen;
	private String importeVta;
	private String activos;
	private String pasivos;
	private String capital;
	private String importa;
	private String dolaresImport;
	private String paisesImport;
	private String paisesImport2;
	private String paisesImport3;
	private String exporta;
	private String dolaresExport;
	private String paisesExport;
	private String paisesExport2;
	private String paisesExport3;
	private String nombRefCom;
	private String nombRefCom2;
	private String telRefCom;
	private String telRefCom2;
	private String bancoRef;
	private String bancoRef2;
	private String noCuentaRef;
	private String noCuentaRef2;
	private String NombreRef;
	private String NombreRef2;
	private String domicilioRef;
	private String domicilioRef2;
	private String telefonoRef;
	private String telefonoRef2;
	private String pFuenteIng;
	private String ingAproxMes;
	private String extTelefonoRefUno;
	private String extTelefonoRefDos;
	private String extTelRefCom;
	private String extTelRefCom2;
	private String tipoRelacion1;
	private String tipoRelacion2;
	private String capitalContable;
	private String noCuentaRefCom;
	private String noCuentaRefCom2;
	private String direccionRefCom;
	private String direccionRefCom2;
	private String banTipoCuentaRef;
	private String banTipoCuentaRef2;
	private String banSucursalRef;
	private String banSucursalRef2;
	private String banNoTarjetaRef;
	private String banNoTarjetaRef2;
	private String banTarjetaInsRef;
	private String banTarjetaInsRef2;
	private String banCredOtraEnt;
	private String banCredOtraEnt2;
	private String banInsOtraEnt;
	private String banInsOtraEnt2;
	private String operacionAnios;
	private String giroAnios;
	// Sólo para clientes de Alto Riesgo
	private String preguntaCte1;
	private String preguntaCte2;
	private String preguntaCte3;
	private String preguntaCte4;
	private String respuestaCte1;
	private String respuestaCte2;
	private String respuestaCte3;
	private String respuestaCte4;
	// FIN clientes de Alto Riesgo
	private String empresaID;
	private String usuario;
	private String sucursal;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String numTransaccion;
	private String nivelRiesgo;
	private String evaluaXMatriz;
	private String comentarioNivel;
	//Cuestionarios Adicionales
	private String fechaNombramiento;
	private String periodoCargo;
	private String porcentajeAcciones;
	private String montoAcciones;
	private String tiposClientes;
	private String instrumentosMonetarios;
	
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getNomGrupo() {
		return nomGrupo;
	}
	public void setNomGrupo(String nomGrupo) {
		this.nomGrupo = nomGrupo;
	}
	public String getRFC() {
		return RFC;
	}
	public void setRFC(String rFC) {
		RFC = rFC;
	}
	public String getParticipacion() {
		return participacion;
	}
	public void setParticipacion(String participacion) {
		this.participacion = participacion;
	}
	public String getNacionalidad() {
		return nacionalidad;
	}
	public void setNacionalidad(String nacionalidad) {
		this.nacionalidad = nacionalidad;
	}
	public String getRazonSocial() {
		return razonSocial;
	}
	public void setRazonSocial(String razonSocial) {
		this.razonSocial = razonSocial;
	}
	public String getGiro() {
		return giro;
	}
	public void setGiro(String giro) {
		this.giro = giro;
	}
	public String getPEPs() {
		return PEPs;
	}
	public void setPEPs(String pEPs) {
		PEPs = pEPs;
	}
	public String getFuncionID() {
		return funcionID;
	}
	public void setFuncionID(String funcionID) {
		this.funcionID = funcionID;
	}
	public String getParentescoPEP() {
		return parentescoPEP;
	}
	public void setParentescoPEP(String parentescoPEP) {
		this.parentescoPEP = parentescoPEP;
	}
	public String getNombFamiliar() {
		return nombFamiliar;
	}
	public void setNombFamiliar(String nombFamiliar) {
		this.nombFamiliar = nombFamiliar;
	}
	public String getaPaternoFam() {
		return aPaternoFam;
	}
	public void setaPaternoFam(String aPaternoFam) {
		this.aPaternoFam = aPaternoFam;
	}
	public String getaMaternoFam() {
		return aMaternoFam;
	}
	public void setaMaternoFam(String aMaternoFam) {
		this.aMaternoFam = aMaternoFam;
	}
	public String getNoEmpleados() {
		return noEmpleados;
	}
	public void setNoEmpleados(String noEmpleados) {
		this.noEmpleados = noEmpleados;
	}
	public String getServ_Produc() {
		return serv_Produc;
	}
	public void setServ_Produc(String serv_Produc) {
		this.serv_Produc = serv_Produc;
	}
	public String getCober_Geograf() {
		return cober_Geograf;
	}
	public void setCober_Geograf(String cober_Geograf) {
		this.cober_Geograf = cober_Geograf;
	}
	public String getEstados_Presen() {
		return estados_Presen;
	}
	public void setEstados_Presen(String estados_Presen) {
		this.estados_Presen = estados_Presen;
	}
	public String getImporteVta() {
		return importeVta;
	}
	public void setImporteVta(String importeVta) {
		this.importeVta = importeVta;
	}
	public String getActivos() {
		return activos;
	}
	public void setActivos(String activos) {
		this.activos = activos;
	}
	public String getPasivos() {
		return pasivos;
	}
	public void setPasivos(String pasivos) {
		this.pasivos = pasivos;
	}
	public String getCapital() {
		return capital;
	}
	public void setCapital(String capital) {
		this.capital = capital;
	}
	public String getImporta() {
		return importa;
	}
	public void setImporta(String importa) {
		this.importa = importa;
	}
	public String getDolaresImport() {
		return dolaresImport;
	}
	public void setDolaresImport(String dolaresImport) {
		this.dolaresImport = dolaresImport;
	}
	public String getPaisesImport() {
		return paisesImport;
	}
	public void setPaisesImport(String paisesImport) {
		this.paisesImport = paisesImport;
	}
	public String getPaisesImport2() {
		return paisesImport2;
	}
	public void setPaisesImport2(String paisesImport2) {
		this.paisesImport2 = paisesImport2;
	}
	public String getPaisesImport3() {
		return paisesImport3;
	}
	public void setPaisesImport3(String paisesImport3) {
		this.paisesImport3 = paisesImport3;
	}
	public String getExporta() {
		return exporta;
	}
	public void setExporta(String exporta) {
		this.exporta = exporta;
	}
	public String getDolaresExport() {
		return dolaresExport;
	}
	public void setDolaresExport(String dolaresExport) {
		this.dolaresExport = dolaresExport;
	}
	public String getPaisesExport() {
		return paisesExport;
	}
	public void setPaisesExport(String paisesExport) {
		this.paisesExport = paisesExport;
	}
	public String getPaisesExport2() {
		return paisesExport2;
	}
	public void setPaisesExport2(String paisesExport2) {
		this.paisesExport2 = paisesExport2;
	}
	public String getPaisesExport3() {
		return paisesExport3;
	}
	public void setPaisesExport3(String paisesExport3) {
		this.paisesExport3 = paisesExport3;
	}
	public String getNombRefCom() {
		return nombRefCom;
	}
	public void setNombRefCom(String nombRefCom) {
		this.nombRefCom = nombRefCom;
	}
	public String getNombRefCom2() {
		return nombRefCom2;
	}
	public void setNombRefCom2(String nombRefCom2) {
		this.nombRefCom2 = nombRefCom2;
	}
	public String getTelRefCom() {
		return telRefCom;
	}
	public void setTelRefCom(String telRefCom) {
		this.telRefCom = telRefCom;
	}
	public String getTelRefCom2() {
		return telRefCom2;
	}
	public void setTelRefCom2(String telRefCom2) {
		this.telRefCom2 = telRefCom2;
	}
	public String getBancoRef() {
		return bancoRef;
	}
	public void setBancoRef(String bancoRef) {
		this.bancoRef = bancoRef;
	}
	public String getBancoRef2() {
		return bancoRef2;
	}
	public void setBancoRef2(String bancoRef2) {
		this.bancoRef2 = bancoRef2;
	}
	public String getNoCuentaRef() {
		return noCuentaRef;
	}
	public void setNoCuentaRef(String noCuentaRef) {
		this.noCuentaRef = noCuentaRef;
	}
	public String getNoCuentaRef2() {
		return noCuentaRef2;
	}
	public void setNoCuentaRef2(String noCuentaRef2) {
		this.noCuentaRef2 = noCuentaRef2;
	}
	public String getNombreRef() {
		return NombreRef;
	}
	public void setNombreRef(String nombreRef) {
		NombreRef = nombreRef;
	}
	public String getNombreRef2() {
		return NombreRef2;
	}
	public void setNombreRef2(String nombreRef2) {
		NombreRef2 = nombreRef2;
	}
	public String getDomicilioRef() {
		return domicilioRef;
	}
	public void setDomicilioRef(String domicilioRef) {
		this.domicilioRef = domicilioRef;
	}
	public String getDomicilioRef2() {
		return domicilioRef2;
	}
	public void setDomicilioRef2(String domicilioRef2) {
		this.domicilioRef2 = domicilioRef2;
	}
	public String getTelefonoRef() {
		return telefonoRef;
	}
	public void setTelefonoRef(String telefonoRef) {
		this.telefonoRef = telefonoRef;
	}
	public String getTelefonoRef2() {
		return telefonoRef2;
	}
	public void setTelefonoRef2(String telefonoRef2) {
		this.telefonoRef2 = telefonoRef2;
	}
	public String getpFuenteIng() {
		return pFuenteIng;
	}
	public void setpFuenteIng(String pFuenteIng) {
		this.pFuenteIng = pFuenteIng;
	}
	public String getIngAproxMes() {
		return ingAproxMes;
	}
	public void setIngAproxMes(String ingAproxMes) {
		this.ingAproxMes = ingAproxMes;
	}
	public String getEmpresaID() {
		return empresaID;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}
	public String getUsuario() {
		return usuario;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	public String getSucursal() {
		return sucursal;
	}
	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
	}
	public String getFechaActual() {
		return fechaActual;
	}
	public void setFechaActual(String fechaActual) {
		this.fechaActual = fechaActual;
	}
	public String getDireccionIP() {
		return direccionIP;
	}
	public void setDireccionIP(String direccionIP) {
		this.direccionIP = direccionIP;
	}
	public String getProgramaID() {
		return programaID;
	}
	public void setProgramaID(String programaID) {
		this.programaID = programaID;
	}
	public String getNumTransaccion() {
		return numTransaccion;
	}
	public void setNumTransaccion(String numTransaccion) {
		this.numTransaccion = numTransaccion;
	}
	public String getExtTelefonoRefUno() {
		return extTelefonoRefUno;
	}
	public void setExtTelefonoRefUno(String extTelefonoRefUno) {
		this.extTelefonoRefUno = extTelefonoRefUno;
	}
	public String getExtTelefonoRefDos() {
		return extTelefonoRefDos;
	}
	public void setExtTelefonoRefDos(String extTelefonoRefDos) {
		this.extTelefonoRefDos = extTelefonoRefDos;
	}
	public String getExtTelRefCom() {
		return extTelRefCom;
	}
	public void setExtTelRefCom(String extTelRefCom) {
		this.extTelRefCom = extTelRefCom;
	}
	public String getExtTelRefCom2() {
		return extTelRefCom2;
	}
	public void setExtTelRefCom2(String extTelRefCom2) {
		this.extTelRefCom2 = extTelRefCom2;
	}
	public String getTipoRelacion1() {
		return tipoRelacion1;
	}
	public void setTipoRelacion1(String tipoRelacion1) {
		this.tipoRelacion1 = tipoRelacion1;
	}
	public String getTipoRelacion2() {
		return tipoRelacion2;
	}
	public void setTipoRelacion2(String tipoRelacion2) {
		this.tipoRelacion2 = tipoRelacion2;
	}
	public String getPreguntaCte1() {
		return preguntaCte1;
	}
	public void setPreguntaCte1(String preguntaCte1) {
		this.preguntaCte1 = preguntaCte1;
	}
	public String getPreguntaCte2() {
		return preguntaCte2;
	}
	public void setPreguntaCte2(String preguntaCte2) {
		this.preguntaCte2 = preguntaCte2;
	}
	public String getPreguntaCte3() {
		return preguntaCte3;
	}
	public void setPreguntaCte3(String preguntaCte3) {
		this.preguntaCte3 = preguntaCte3;
	}
	public String getPreguntaCte4() {
		return preguntaCte4;
	}
	public void setPreguntaCte4(String preguntaCte4) {
		this.preguntaCte4 = preguntaCte4;
	}
	public String getRespuestaCte1() {
		return respuestaCte1;
	}
	public void setRespuestaCte1(String respuestaCte1) {
		this.respuestaCte1 = respuestaCte1;
	}
	public String getRespuestaCte2() {
		return respuestaCte2;
	}
	public void setRespuestaCte2(String respuestaCte2) {
		this.respuestaCte2 = respuestaCte2;
	}
	public String getRespuestaCte3() {
		return respuestaCte3;
	}
	public void setRespuestaCte3(String respuestaCte3) {
		this.respuestaCte3 = respuestaCte3;
	}
	public String getRespuestaCte4() {
		return respuestaCte4;
	}
	public void setRespuestaCte4(String respuestaCte4) {
		this.respuestaCte4 = respuestaCte4;
	}
	public String getCapitalContable() {
		return capitalContable;
	}
	public void setCapitalContable(String capitalContable) {
		this.capitalContable = capitalContable;
	}
	public String getNoCuentaRefCom() {
		return noCuentaRefCom;
	}
	public void setNoCuentaRefCom(String noCuentaRefCom) {
		this.noCuentaRefCom = noCuentaRefCom;
	}
	public String getNoCuentaRefCom2() {
		return noCuentaRefCom2;
	}
	public void setNoCuentaRefCom2(String noCuentaRefCom2) {
		this.noCuentaRefCom2 = noCuentaRefCom2;
	}
	public String getDireccionRefCom() {
		return direccionRefCom;
	}
	public void setDireccionRefCom(String direccionRefCom) {
		this.direccionRefCom = direccionRefCom;
	}
	public String getDireccionRefCom2() {
		return direccionRefCom2;
	}
	public void setDireccionRefCom2(String direccionRefCom2) {
		this.direccionRefCom2 = direccionRefCom2;
	}
	public String getBanTipoCuentaRef() {
		return banTipoCuentaRef;
	}
	public void setBanTipoCuentaRef(String banTipoCuentaRef) {
		this.banTipoCuentaRef = banTipoCuentaRef;
	}
	public String getBanTipoCuentaRef2() {
		return banTipoCuentaRef2;
	}
	public void setBanTipoCuentaRef2(String banTipoCuentaRef2) {
		this.banTipoCuentaRef2 = banTipoCuentaRef2;
	}
	public String getBanSucursalRef() {
		return banSucursalRef;
	}
	public void setBanSucursalRef(String banSucursalRef) {
		this.banSucursalRef = banSucursalRef;
	}
	public String getBanSucursalRef2() {
		return banSucursalRef2;
	}
	public void setBanSucursalRef2(String banSucursalRef2) {
		this.banSucursalRef2 = banSucursalRef2;
	}
	public String getBanNoTarjetaRef() {
		return banNoTarjetaRef;
	}
	public void setBanNoTarjetaRef(String banNoTarjetaRef) {
		this.banNoTarjetaRef = banNoTarjetaRef;
	}
	public String getBanNoTarjetaRef2() {
		return banNoTarjetaRef2;
	}
	public void setBanNoTarjetaRef2(String banNoTarjetaRef2) {
		this.banNoTarjetaRef2 = banNoTarjetaRef2;
	}
	public String getBanTarjetaInsRef() {
		return banTarjetaInsRef;
	}
	public void setBanTarjetaInsRef(String banTarjetaInsRef) {
		this.banTarjetaInsRef = banTarjetaInsRef;
	}
	public String getBanTarjetaInsRef2() {
		return banTarjetaInsRef2;
	}
	public void setBanTarjetaInsRef2(String banTarjetaInsRef2) {
		this.banTarjetaInsRef2 = banTarjetaInsRef2;
	}
	public String getBanCredOtraEnt() {
		return banCredOtraEnt;
	}
	public void setBanCredOtraEnt(String banCredOtraEnt) {
		this.banCredOtraEnt = banCredOtraEnt;
	}
	public String getBanCredOtraEnt2() {
		return banCredOtraEnt2;
	}
	public void setBanCredOtraEnt2(String banCredOtraEnt2) {
		this.banCredOtraEnt2 = banCredOtraEnt2;
	}
	public String getBanInsOtraEnt() {
		return banInsOtraEnt;
	}
	public void setBanInsOtraEnt(String banInsOtraEnt) {
		this.banInsOtraEnt = banInsOtraEnt;
	}
	public String getBanInsOtraEnt2() {
		return banInsOtraEnt2;
	}
	public void setBanInsOtraEnt2(String banInsOtraEnt2) {
		this.banInsOtraEnt2 = banInsOtraEnt2;
	}
	public String getNivelRiesgo() {
		return nivelRiesgo;
	}
	public void setNivelRiesgo(String nivelRiesgo) {
		this.nivelRiesgo = nivelRiesgo;
	}
	public String getEvaluaXMatriz() {
		return evaluaXMatriz;
	}
	public void setEvaluaXMatriz(String evaluaXMatriz) {
		this.evaluaXMatriz = evaluaXMatriz;
	}
	public String getComentarioNivel() {
		return comentarioNivel;
	}
	public void setComentarioNivel(String comentarioNivel) {
		this.comentarioNivel = comentarioNivel;
	}
	public String getFechaNombramiento() {
		return fechaNombramiento;
	}
	public void setFechaNombramiento(String fechaNombramiento) {
		this.fechaNombramiento = fechaNombramiento;
	}
	public String getPeriodoCargo() {
		return periodoCargo;
	}
	public void setPeriodoCargo(String periodoCargo) {
		this.periodoCargo = periodoCargo;
	}
	public String getPorcentajeAcciones() {
		return porcentajeAcciones;
	}
	public void setPorcentajeAcciones(String porcentajeAcciones) {
		this.porcentajeAcciones = porcentajeAcciones;
	}
	public String getMontoAcciones() {
		return montoAcciones;
	}
	public void setMontoAcciones(String montoAcciones) {
		this.montoAcciones = montoAcciones;
	}
	public String getTiposClientes() {
		return tiposClientes;
	}
	public void setTiposClientes(String tiposClientes) {
		this.tiposClientes = tiposClientes;
	}
	public String getInstrumentosMonetarios() {
		return instrumentosMonetarios;
	}
	public void setInstrumentosMonetarios(String instrumentosMonetarios) {
		this.instrumentosMonetarios = instrumentosMonetarios;
	}
	public String getOperacionAnios() {
		return operacionAnios;
	}
	public void setOperacionAnios(String operacionAnios) {
		this.operacionAnios = operacionAnios;
	}
	public String getGiroAnios() {
		return giroAnios;
	}
	public void setGiroAnios(String giroAnios) {
		this.giroAnios = giroAnios;
	}
	
}