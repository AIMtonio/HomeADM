package pld.bean;

import general.bean.BaseBean;

public class ConocimientoUsuarioServiciosBean extends BaseBean {

	private String usuarioID;

    // En caso de pertenecer a una sociedad, grupo o filial.
	private String nombreGrupo;
	private String RFC;
	private String participacion;
	private String nacionalidad;

    // En caso de tener actividad empresarial.
	private String razonSocial;
	private String giro;
    private String aniosOperacion;
    private String aniosGiro;
	private String PEPs;
	private String funcionID;
	private String funcionDescripcion;
	private String fechaNombramiento;
	private String porcentajeAcciones;
	private String periodoCargo;
	private String montoAcciones;
    private String parentescoPEP;
	private String nombreFamiliar;
	private String aPaternoFamiliar;
	private String aMaternoFamiliar;
    private String numeroEmpleados;
    private String serviciosProductos;
    private String coberturaGeografica;
    private String estadosPresencia;
    private String importeVentas;
    private String activos;
    private String pasivos;
    private String capitalContable;
    private String capitalNeto;
    private String importa;
	private String dolaresImporta;
	private String paisesImporta1;
	private String paisesImporta2;
	private String paisesImporta3;
    private String exporta;
	private String dolaresExporta;
	private String paisesExporta1;
	private String paisesExporta2;
	private String paisesExporta3;
    private String tiposClientes;
    private String instrMonetarios;

    // Referencias Comerciales (Clientes/Proveedores).
    private String nombreRefCom1;
    private String noCuentaRefCom1;
    private String direccionRefCom1;
    private String telefonoRefCom1;
    private String ExtTelefonoRefCom1;
    private String nombreRefCom2;
    private String noCuentaRefCom2;
    private String direccionRefCom2;
    private String telefonoRefCom2;
    private String ExtTelefonoRefCom2;

    // Referencias Bancarias.
    private String bancoRefBanc1;
    private String tipoCuentaRefBanc1;
    private String noCuentaRefBanc1;
    private String sucursalRefBanc1;
    private String noTarjetaRefBanc1;
    private String institucionRefBanc1;
    private String credOtraEntRefBanc1;
    private String institucionEntRefBanc1;
    private String bancoRefBanc2;
    private String tipoCuentaRefBanc2;
    private String noCuentaRefBanc2;
    private String sucursalRefBanc2;
    private String noTarjetaRefBanc2;
    private String institucionRefBanc2;
    private String credOtraEntRefBanc2;
    private String institucionEntRefBanc2;

    // Referencias que no vivan en su domicilio.
    private String nombreRefPers1;
    private String domicilioRefPers1;
    private String telefonoRefPers1;
    private String extTelefonoRefPers1;
    private String tipoRelacionRefPers1;
	private String tipoRelacion1Desc;
    private String nombreRefPers2;
    private String domicilioRefPers2;
    private String telefonoRefPers2;
    private String extTelefonoRefPers2;
    private String tipoRelacionRefPers2;
	private String tipoRelacion2Desc;

	// campos preguntas y respuestas por usuario de alto riesgo
	private String preguntaUsuario1;
	private String respuestaUsuario1;
	private String preguntaUsuario2;
	private String respuestaUsuario2;
	private String preguntaUsuario3;
	private String respuestaUsuario3;
	private String preguntaUsuario4;
	private String respuestaUsuario4;

    private String principalFuenteIng;
    private String ingAproxPorMes;

	// mostrarOC
	private String nivelRiesgo;
	private String evaluaXMatriz;
	private String comentarioNivel;


	public String getUsuarioID() {
		return usuarioID;
	}
	public void setUsuarioID(String usuarioID) {
		this.usuarioID = usuarioID;
	}
	public String getNombreGrupo() {
		return nombreGrupo;
	}
	public void setNombreGrupo(String nombreGrupo) {
		this.nombreGrupo = nombreGrupo;
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
	public String getAniosOperacion() {
		return aniosOperacion;
	}
	public void setAniosOperacion(String aniosOperacion) {
		this.aniosOperacion = aniosOperacion;
	}
	public String getAniosGiro() {
		return aniosGiro;
	}
	public void setAniosGiro(String aniosGiro) {
		this.aniosGiro = aniosGiro;
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
	public String getFuncionDescripcion() {
		return funcionDescripcion;
	}
	public void setFuncionDescripcion(String funcionDescripcion) {
		this.funcionDescripcion = funcionDescripcion;
	}
	public String getFechaNombramiento() {
		return fechaNombramiento;
	}
	public void setFechaNombramiento(String fechaNombramiento) {
		this.fechaNombramiento = fechaNombramiento;
	}
	public String getPorcentajeAcciones() {
		return porcentajeAcciones;
	}
	public void setPorcentajeAcciones(String porcentajeAcciones) {
		this.porcentajeAcciones = porcentajeAcciones;
	}
	public String getPeriodoCargo() {
		return periodoCargo;
	}
	public void setPeriodoCargo(String periodoCargo) {
		this.periodoCargo = periodoCargo;
	}
	public String getMontoAcciones() {
		return montoAcciones;
	}
	public void setMontoAcciones(String montoAcciones) {
		this.montoAcciones = montoAcciones;
	}
	public String getParentescoPEP() {
		return parentescoPEP;
	}
	public void setParentescoPEP(String parentescoPEP) {
		this.parentescoPEP = parentescoPEP;
	}
	public String getNombreFamiliar() {
		return nombreFamiliar;
	}
	public void setNombreFamiliar(String nombreFamiliar) {
		this.nombreFamiliar = nombreFamiliar;
	}
	public String getaPaternoFamiliar() {
		return aPaternoFamiliar;
	}
	public void setaPaternoFamiliar(String aPaternoFamiliar) {
		this.aPaternoFamiliar = aPaternoFamiliar;
	}
	public String getaMaternoFamiliar() {
		return aMaternoFamiliar;
	}
	public void setaMaternoFamiliar(String aMaternoFamiliar) {
		this.aMaternoFamiliar = aMaternoFamiliar;
	}
	public String getNumeroEmpleados() {
		return numeroEmpleados;
	}
	public void setNumeroEmpleados(String numeroEmpleados) {
		this.numeroEmpleados = numeroEmpleados;
	}
	public String getServiciosProductos() {
		return serviciosProductos;
	}
	public void setServiciosProductos(String serviciosProductos) {
		this.serviciosProductos = serviciosProductos;
	}
	public String getCoberturaGeografica() {
		return coberturaGeografica;
	}
	public void setCoberturaGeografica(String coberturaGeografica) {
		this.coberturaGeografica = coberturaGeografica;
	}
	public String getEstadosPresencia() {
		return estadosPresencia;
	}
	public void setEstadosPresencia(String estadosPresencia) {
		this.estadosPresencia = estadosPresencia;
	}
	public String getImporteVentas() {
		return importeVentas;
	}
	public void setImporteVentas(String importeVentas) {
		this.importeVentas = importeVentas;
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
	public String getCapitalContable() {
		return capitalContable;
	}
	public void setCapitalContable(String capitalContable) {
		this.capitalContable = capitalContable;
	}
	public String getCapitalNeto() {
		return capitalNeto;
	}
	public void setCapitalNeto(String capitalNeto) {
		this.capitalNeto = capitalNeto;
	}
	public String getImporta() {
		return importa;
	}
	public void setImporta(String importa) {
		this.importa = importa;
	}
	public String getDolaresImporta() {
		return dolaresImporta;
	}
	public void setDolaresImporta(String dolaresImporta) {
		this.dolaresImporta = dolaresImporta;
	}
	public String getPaisesImporta1() {
		return paisesImporta1;
	}
	public void setPaisesImporta1(String paisesImporta1) {
		this.paisesImporta1 = paisesImporta1;
	}
	public String getPaisesImporta2() {
		return paisesImporta2;
	}
	public void setPaisesImporta2(String paisesImporta2) {
		this.paisesImporta2 = paisesImporta2;
	}
	public String getPaisesImporta3() {
		return paisesImporta3;
	}
	public void setPaisesImporta3(String paisesImporta3) {
		this.paisesImporta3 = paisesImporta3;
	}
	public String getExporta() {
		return exporta;
	}
	public void setExporta(String exporta) {
		this.exporta = exporta;
	}
	public String getDolaresExporta() {
		return dolaresExporta;
	}
	public void setDolaresExporta(String dolaresExporta) {
		this.dolaresExporta = dolaresExporta;
	}
	public String getPaisesExporta1() {
		return paisesExporta1;
	}
	public void setPaisesExporta1(String paisesExporta1) {
		this.paisesExporta1 = paisesExporta1;
	}
	public String getPaisesExporta2() {
		return paisesExporta2;
	}
	public void setPaisesExporta2(String paisesExporta2) {
		this.paisesExporta2 = paisesExporta2;
	}
	public String getPaisesExporta3() {
		return paisesExporta3;
	}
	public void setPaisesExporta3(String paisesExporta3) {
		this.paisesExporta3 = paisesExporta3;
	}
	public String getTiposClientes() {
		return tiposClientes;
	}
	public void setTiposClientes(String tiposClientes) {
		this.tiposClientes = tiposClientes;
	}
	public String getInstrMonetarios() {
		return instrMonetarios;
	}
	public void setInstrMonetarios(String instrMonetarios) {
		this.instrMonetarios = instrMonetarios;
	}
	public String getNombreRefCom1() {
		return nombreRefCom1;
	}
	public void setNombreRefCom1(String nombreRefCom1) {
		this.nombreRefCom1 = nombreRefCom1;
	}
	public String getNoCuentaRefCom1() {
		return noCuentaRefCom1;
	}
	public void setNoCuentaRefCom1(String noCuentaRefCom1) {
		this.noCuentaRefCom1 = noCuentaRefCom1;
	}
	public String getDireccionRefCom1() {
		return direccionRefCom1;
	}
	public void setDireccionRefCom1(String direccionRefCom1) {
		this.direccionRefCom1 = direccionRefCom1;
	}
	public String getTelefonoRefCom1() {
		return telefonoRefCom1;
	}
	public void setTelefonoRefCom1(String telefonoRefCom1) {
		this.telefonoRefCom1 = telefonoRefCom1;
	}
	public String getExtTelefonoRefCom1() {
		return ExtTelefonoRefCom1;
	}
	public void setExtTelefonoRefCom1(String extTelefonoRefCom1) {
		ExtTelefonoRefCom1 = extTelefonoRefCom1;
	}
	public String getNombreRefCom2() {
		return nombreRefCom2;
	}
	public void setNombreRefCom2(String nombreRefCom2) {
		this.nombreRefCom2 = nombreRefCom2;
	}
	public String getNoCuentaRefCom2() {
		return noCuentaRefCom2;
	}
	public void setNoCuentaRefCom2(String noCuentaRefCom2) {
		this.noCuentaRefCom2 = noCuentaRefCom2;
	}
	public String getDireccionRefCom2() {
		return direccionRefCom2;
	}
	public void setDireccionRefCom2(String direccionRefCom2) {
		this.direccionRefCom2 = direccionRefCom2;
	}
	public String getTelefonoRefCom2() {
		return telefonoRefCom2;
	}
	public void setTelefonoRefCom2(String telefonoRefCom2) {
		this.telefonoRefCom2 = telefonoRefCom2;
	}
	public String getExtTelefonoRefCom2() {
		return ExtTelefonoRefCom2;
	}
	public void setExtTelefonoRefCom2(String extTelefonoRefCom2) {
		ExtTelefonoRefCom2 = extTelefonoRefCom2;
	}
	public String getBancoRefBanc1() {
		return bancoRefBanc1;
	}
	public void setBancoRefBanc1(String bancoRefBanc1) {
		this.bancoRefBanc1 = bancoRefBanc1;
	}
	public String getTipoCuentaRefBanc1() {
		return tipoCuentaRefBanc1;
	}
	public void setTipoCuentaRefBanc1(String tipoCuentaRefBanc1) {
		this.tipoCuentaRefBanc1 = tipoCuentaRefBanc1;
	}
	public String getNoCuentaRefBanc1() {
		return noCuentaRefBanc1;
	}
	public void setNoCuentaRefBanc1(String noCuentaRefBanc1) {
		this.noCuentaRefBanc1 = noCuentaRefBanc1;
	}
	public String getSucursalRefBanc1() {
		return sucursalRefBanc1;
	}
	public void setSucursalRefBanc1(String sucursalRefBanc1) {
		this.sucursalRefBanc1 = sucursalRefBanc1;
	}
	public String getNoTarjetaRefBanc1() {
		return noTarjetaRefBanc1;
	}
	public void setNoTarjetaRefBanc1(String noTarjetaRefBanc1) {
		this.noTarjetaRefBanc1 = noTarjetaRefBanc1;
	}
	public String getInstitucionRefBanc1() {
		return institucionRefBanc1;
	}
	public void setInstitucionRefBanc1(String institucionRefBanc1) {
		this.institucionRefBanc1 = institucionRefBanc1;
	}
	public String getCredOtraEntRefBanc1() {
		return credOtraEntRefBanc1;
	}
	public void setCredOtraEntRefBanc1(String credOtraEntRefBanc1) {
		this.credOtraEntRefBanc1 = credOtraEntRefBanc1;
	}
	public String getInstitucionEntRefBanc1() {
		return institucionEntRefBanc1;
	}
	public void setInstitucionEntRefBanc1(String institucionEntRefBanc1) {
		this.institucionEntRefBanc1 = institucionEntRefBanc1;
	}
	public String getBancoRefBanc2() {
		return bancoRefBanc2;
	}
	public void setBancoRefBanc2(String bancoRefBanc2) {
		this.bancoRefBanc2 = bancoRefBanc2;
	}
	public String getTipoCuentaRefBanc2() {
		return tipoCuentaRefBanc2;
	}
	public void setTipoCuentaRefBanc2(String tipoCuentaRefBanc2) {
		this.tipoCuentaRefBanc2 = tipoCuentaRefBanc2;
	}
	public String getNoCuentaRefBanc2() {
		return noCuentaRefBanc2;
	}
	public void setNoCuentaRefBanc2(String noCuentaRefBanc2) {
		this.noCuentaRefBanc2 = noCuentaRefBanc2;
	}
	public String getSucursalRefBanc2() {
		return sucursalRefBanc2;
	}
	public void setSucursalRefBanc2(String sucursalRefBanc2) {
		this.sucursalRefBanc2 = sucursalRefBanc2;
	}
	public String getNoTarjetaRefBanc2() {
		return noTarjetaRefBanc2;
	}
	public void setNoTarjetaRefBanc2(String noTarjetaRefBanc2) {
		this.noTarjetaRefBanc2 = noTarjetaRefBanc2;
	}
	public String getInstitucionRefBanc2() {
		return institucionRefBanc2;
	}
	public void setInstitucionRefBanc2(String institucionRefBanc2) {
		this.institucionRefBanc2 = institucionRefBanc2;
	}
	public String getCredOtraEntRefBanc2() {
		return credOtraEntRefBanc2;
	}
	public void setCredOtraEntRefBanc2(String credOtraEntRefBanc2) {
		this.credOtraEntRefBanc2 = credOtraEntRefBanc2;
	}
	public String getInstitucionEntRefBanc2() {
		return institucionEntRefBanc2;
	}
	public void setInstitucionEntRefBanc2(String institucionEntRefBanc2) {
		this.institucionEntRefBanc2 = institucionEntRefBanc2;
	}
	public String getNombreRefPers1() {
		return nombreRefPers1;
	}
	public void setNombreRefPers1(String nombreRefPers1) {
		this.nombreRefPers1 = nombreRefPers1;
	}
	public String getDomicilioRefPers1() {
		return domicilioRefPers1;
	}
	public void setDomicilioRefPers1(String domicilioRefPers1) {
		this.domicilioRefPers1 = domicilioRefPers1;
	}
	public String getTelefonoRefPers1() {
		return telefonoRefPers1;
	}
	public void setTelefonoRefPers1(String telefonoRefPers1) {
		this.telefonoRefPers1 = telefonoRefPers1;
	}
	public String getExtTelefonoRefPers1() {
		return extTelefonoRefPers1;
	}
	public void setExtTelefonoRefPers1(String extTelefonoRefPers1) {
		this.extTelefonoRefPers1 = extTelefonoRefPers1;
	}
	public String getTipoRelacionRefPers1() {
		return tipoRelacionRefPers1;
	}
	public void setTipoRelacionRefPers1(String tipoRelacionRefPers1) {
		this.tipoRelacionRefPers1 = tipoRelacionRefPers1;
	}
	public String getTipoRelacion1Desc() {
		return tipoRelacion1Desc;
	}
	public void setTipoRelacion1Desc(String tipoRelacion1Desc) {
		this.tipoRelacion1Desc = tipoRelacion1Desc;
	}
	public String getNombreRefPers2() {
		return nombreRefPers2;
	}
	public void setNombreRefPers2(String nombreRefPers2) {
		this.nombreRefPers2 = nombreRefPers2;
	}
	public String getDomicilioRefPers2() {
		return domicilioRefPers2;
	}
	public void setDomicilioRefPers2(String domicilioRefPers2) {
		this.domicilioRefPers2 = domicilioRefPers2;
	}
	public String getTelefonoRefPers2() {
		return telefonoRefPers2;
	}
	public void setTelefonoRefPers2(String telefonoRefPers2) {
		this.telefonoRefPers2 = telefonoRefPers2;
	}
	public String getExtTelefonoRefPers2() {
		return extTelefonoRefPers2;
	}
	public void setExtTelefonoRefPers2(String extTelefonoRefPers2) {
		this.extTelefonoRefPers2 = extTelefonoRefPers2;
	}
	public String getTipoRelacionRefPers2() {
		return tipoRelacionRefPers2;
	}
	public void setTipoRelacionRefPers2(String tipoRelacionRefPers2) {
		this.tipoRelacionRefPers2 = tipoRelacionRefPers2;
	}
	public String getTipoRelacion2Desc() {
		return tipoRelacion2Desc;
	}
	public void setTipoRelacion2Desc(String tipoRelacion2Desc) {
		this.tipoRelacion2Desc = tipoRelacion2Desc;
	}
	public String getPreguntaUsuario1() {
		return preguntaUsuario1;
	}
	public void setPreguntaUsuario1(String preguntaUsuario1) {
		this.preguntaUsuario1 = preguntaUsuario1;
	}
	public String getRespuestaUsuario1() {
		return respuestaUsuario1;
	}
	public void setRespuestaUsuario1(String respuestaUsuario1) {
		this.respuestaUsuario1 = respuestaUsuario1;
	}
	public String getPreguntaUsuario2() {
		return preguntaUsuario2;
	}
	public void setPreguntaUsuario2(String preguntaUsuario2) {
		this.preguntaUsuario2 = preguntaUsuario2;
	}
	public String getRespuestaUsuario2() {
		return respuestaUsuario2;
	}
	public void setRespuestaUsuario2(String respuestaUsuario2) {
		this.respuestaUsuario2 = respuestaUsuario2;
	}
	public String getPreguntaUsuario3() {
		return preguntaUsuario3;
	}
	public void setPreguntaUsuario3(String preguntaUsuario3) {
		this.preguntaUsuario3 = preguntaUsuario3;
	}
	public String getRespuestaUsuario3() {
		return respuestaUsuario3;
	}
	public void setRespuestaUsuario3(String respuestaUsuario3) {
		this.respuestaUsuario3 = respuestaUsuario3;
	}
	public String getPreguntaUsuario4() {
		return preguntaUsuario4;
	}
	public void setPreguntaUsuario4(String preguntaUsuario4) {
		this.preguntaUsuario4 = preguntaUsuario4;
	}
	public String getRespuestaUsuario4() {
		return respuestaUsuario4;
	}
	public void setRespuestaUsuario4(String respuestaUsuario4) {
		this.respuestaUsuario4 = respuestaUsuario4;
	}
	public String getPrincipalFuenteIng() {
		return principalFuenteIng;
	}
	public void setPrincipalFuenteIng(String principalFuenteIng) {
		this.principalFuenteIng = principalFuenteIng;
	}
	public String getIngAproxPorMes() {
		return ingAproxPorMes;
	}
	public void setIngAproxPorMes(String ingAproxPorMes) {
		this.ingAproxPorMes = ingAproxPorMes;
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
}