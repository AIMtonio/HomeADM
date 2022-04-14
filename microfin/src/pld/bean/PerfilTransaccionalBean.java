package pld.bean;

import general.bean.BaseBean;

public class PerfilTransaccionalBean extends BaseBean{
	private String clienteID;
	private String usuarioID;
	private String nombreCompleto;
	private String depositosMax;
	private String retirosMax;
	private String numDepositos;
	private String numRetiros;
	private String numDepoApli;
	private String numRetiApli;
	private String origenRecursos;
	private String descripcionOrigen;
	private String destinoRecursos;
	private String descripcionDestino;
	private String comentarioOrigenRec;
	private String comentarioDestRec;
	private String fecha;
	private String hora;
	private String tipoProceso;
	private String numDepoEfec;
	private String numDepoChe;
	private String numDepoTran;
	private String numRetirosEfec;
	private String numRetirosChe;
	private String numRetirosTran;
	private String numDepoEfecApli;
	private String numDepoCheApli;
	private String numDepoTranApli;
	private String numRetirosEfecApli;
	private String numRetirosCheApli;
	private String numRetirosTranApli;
	private String sucursalID;
	private String nombreSucursal;
	private String fechaIncio;
	private String fechaFin;
	private String detalles;
	private String estatus;
	private String tipoPersona;

	private String sucursalOrigen;
	private String nombreSucurs;
	private String antDepositosMax;
	private String porcExcDepo;
	private String antRetirosMax;
	private String retirosExc;
	private String antNumDepositos;
	private String numDepEx;
	private String antNumRetiros;
	private String numRetEx;
	private String nivelRiesgo;

	/*Reporte*/
	private String usuario;
	private String fechaInicio;
	private String fechaFinal;
	private String fechaSistema;
	private String horaEmision;
	private String tituloReporte;
	private String tipoPersonaDes;
	private String nivelRiesgoDes;
	private String sucursalDes;
	private String nombreInstitucion;
	
	private String operaciones;
	private String descOperaciones;
	
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getUsuarioID() {
		return usuarioID;
	}
	public void setUsuarioID(String usuarioID) {
		this.usuarioID = usuarioID;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public String getDepositosMax() {
		return depositosMax;
	}
	public void setDepositosMax(String depositosMax) {
		this.depositosMax = depositosMax;
	}
	public String getRetirosMax() {
		return retirosMax;
	}
	public void setRetirosMax(String retirosMax) {
		this.retirosMax = retirosMax;
	}
	public String getNumDepositos() {
		return numDepositos;
	}
	public void setNumDepositos(String numDepositos) {
		this.numDepositos = numDepositos;
	}
	public String getNumRetiros() {
		return numRetiros;
	}
	public void setNumRetiros(String numRetiros) {
		this.numRetiros = numRetiros;
	}
	public String getNumDepoApli() {
		return numDepoApli;
	}
	public void setNumDepoApli(String numDepoApli) {
		this.numDepoApli = numDepoApli;
	}
	public String getNumRetiApli() {
		return numRetiApli;
	}
	public void setNumRetiApli(String numRetiApli) {
		this.numRetiApli = numRetiApli;
	}
	public String getOrigenRecursos() {
		return origenRecursos;
	}
	public void setOrigenRecursos(String origenRecursos) {
		this.origenRecursos = origenRecursos;
	}
	public String getDescripcionOrigen() {
		return descripcionOrigen;
	}
	public void setDescripcionOrigen(String descripcionOrigen) {
		this.descripcionOrigen = descripcionOrigen;
	}
	public String getDestinoRecursos() {
		return destinoRecursos;
	}
	public void setDestinoRecursos(String destinoRecursos) {
		this.destinoRecursos = destinoRecursos;
	}
	public String getDescripcionDestino() {
		return descripcionDestino;
	}
	public void setDescripcionDestino(String descripcionDestino) {
		this.descripcionDestino = descripcionDestino;
	}
	public String getComentarioOrigenRec() {
		return comentarioOrigenRec;
	}
	public void setComentarioOrigenRec(String comentarioOrigenRec) {
		this.comentarioOrigenRec = comentarioOrigenRec;
	}
	public String getComentarioDestRec() {
		return comentarioDestRec;
	}
	public void setComentarioDestRec(String comentarioDestRec) {
		this.comentarioDestRec = comentarioDestRec;
	}
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	public String getHora() {
		return hora;
	}
	public void setHora(String hora) {
		this.hora = hora;
	}
	public String getTipoProceso() {
		return tipoProceso;
	}
	public void setTipoProceso(String tipoProceso) {
		this.tipoProceso = tipoProceso;
	}
	public String getNumDepoEfec() {
		return numDepoEfec;
	}
	public void setNumDepoEfec(String numDepoEfec) {
		this.numDepoEfec = numDepoEfec;
	}
	public String getNumDepoChe() {
		return numDepoChe;
	}
	public void setNumDepoChe(String numDepoChe) {
		this.numDepoChe = numDepoChe;
	}
	public String getNumDepoTran() {
		return numDepoTran;
	}
	public void setNumDepoTran(String numDepoTran) {
		this.numDepoTran = numDepoTran;
	}
	public String getNumRetirosEfec() {
		return numRetirosEfec;
	}
	public void setNumRetirosEfec(String numRetirosEfec) {
		this.numRetirosEfec = numRetirosEfec;
	}
	public String getNumRetirosChe() {
		return numRetirosChe;
	}
	public void setNumRetirosChe(String numRetirosChe) {
		this.numRetirosChe = numRetirosChe;
	}
	public String getNumRetirosTran() {
		return numRetirosTran;
	}
	public void setNumRetirosTran(String numRetirosTran) {
		this.numRetirosTran = numRetirosTran;
	}
	public String getNumDepoEfecApli() {
		return numDepoEfecApli;
	}
	public void setNumDepoEfecApli(String numDepoEfecApli) {
		this.numDepoEfecApli = numDepoEfecApli;
	}
	public String getNumDepoCheApli() {
		return numDepoCheApli;
	}
	public void setNumDepoCheApli(String numDepoCheApli) {
		this.numDepoCheApli = numDepoCheApli;
	}
	public String getNumDepoTranApli() {
		return numDepoTranApli;
	}
	public void setNumDepoTranApli(String numDepoTranApli) {
		this.numDepoTranApli = numDepoTranApli;
	}
	public String getNumRetirosEfecApli() {
		return numRetirosEfecApli;
	}
	public void setNumRetirosEfecApli(String numRetirosEfecApli) {
		this.numRetirosEfecApli = numRetirosEfecApli;
	}
	public String getNumRetirosCheApli() {
		return numRetirosCheApli;
	}
	public void setNumRetirosCheApli(String numRetirosCheApli) {
		this.numRetirosCheApli = numRetirosCheApli;
	}
	public String getNumRetirosTranApli() {
		return numRetirosTranApli;
	}
	public void setNumRetirosTranApli(String numRetirosTranApli) {
		this.numRetirosTranApli = numRetirosTranApli;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getNombreSucursal() {
		return nombreSucursal;
	}
	public void setNombreSucursal(String nombreSucursal) {
		this.nombreSucursal = nombreSucursal;
	}
	public String getFechaIncio() {
		return fechaIncio;
	}
	public void setFechaIncio(String fechaIncio) {
		this.fechaIncio = fechaIncio;
	}
	public String getFechaFin() {
		return fechaFin;
	}
	public void setFechaFin(String fechaFin) {
		this.fechaFin = fechaFin;
	}
	public String getDetalles() {
		return detalles;
	}
	public void setDetalles(String detalles) {
		this.detalles = detalles;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getTipoPersona() {
		return tipoPersona;
	}
	public void setTipoPersona(String tipoPersona) {
		this.tipoPersona = tipoPersona;
	}
	public String getSucursalOrigen() {
		return sucursalOrigen;
	}
	public void setSucursalOrigen(String sucursalOrigen) {
		this.sucursalOrigen = sucursalOrigen;
	}
	public String getNombreSucurs() {
		return nombreSucurs;
	}
	public void setNombreSucurs(String nombreSucurs) {
		this.nombreSucurs = nombreSucurs;
	}
	public String getAntDepositosMax() {
		return antDepositosMax;
	}
	public void setAntDepositosMax(String antDepositosMax) {
		this.antDepositosMax = antDepositosMax;
	}
	public String getPorcExcDepo() {
		return porcExcDepo;
	}
	public void setPorcExcDepo(String porcExcDepo) {
		this.porcExcDepo = porcExcDepo;
	}
	public String getAntRetirosMax() {
		return antRetirosMax;
	}
	public void setAntRetirosMax(String antRetirosMax) {
		this.antRetirosMax = antRetirosMax;
	}
	public String getRetirosExc() {
		return retirosExc;
	}
	public void setRetirosExc(String retirosExc) {
		this.retirosExc = retirosExc;
	}
	public String getAntNumDepositos() {
		return antNumDepositos;
	}
	public void setAntNumDepositos(String antNumDepositos) {
		this.antNumDepositos = antNumDepositos;
	}
	public String getNumDepEx() {
		return numDepEx;
	}
	public void setNumDepEx(String numDepEx) {
		this.numDepEx = numDepEx;
	}
	public String getAntNumRetiros() {
		return antNumRetiros;
	}
	public void setAntNumRetiros(String antNumRetiros) {
		this.antNumRetiros = antNumRetiros;
	}
	public String getNumRetEx() {
		return numRetEx;
	}
	public void setNumRetEx(String numRetEx) {
		this.numRetEx = numRetEx;
	}
	public String getNivelRiesgo() {
		return nivelRiesgo;
	}
	public void setNivelRiesgo(String nivelRiesgo) {
		this.nivelRiesgo = nivelRiesgo;
	}
	public String getUsuario() {
		return usuario;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	public String getFechaInicio() {
		return fechaInicio;
	}
	public void setFechaInicio(String fechaInicio) {
		this.fechaInicio = fechaInicio;
	}
	public String getFechaFinal() {
		return fechaFinal;
	}
	public void setFechaFinal(String fechaFinal) {
		this.fechaFinal = fechaFinal;
	}
	public String getFechaSistema() {
		return fechaSistema;
	}
	public void setFechaSistema(String fechaSistema) {
		this.fechaSistema = fechaSistema;
	}
	public String getHoraEmision() {
		return horaEmision;
	}
	public void setHoraEmision(String horaEmision) {
		this.horaEmision = horaEmision;
	}
	public String getTituloReporte() {
		return tituloReporte;
	}
	public void setTituloReporte(String tituloReporte) {
		this.tituloReporte = tituloReporte;
	}
	public String getTipoPersonaDes() {
		return tipoPersonaDes;
	}
	public void setTipoPersonaDes(String tipoPersonaDes) {
		this.tipoPersonaDes = tipoPersonaDes;
	}
	public String getNivelRiesgoDes() {
		return nivelRiesgoDes;
	}
	public void setNivelRiesgoDes(String nivelRiesgoDes) {
		this.nivelRiesgoDes = nivelRiesgoDes;
	}
	public String getSucursalDes() {
		return sucursalDes;
	}
	public void setSucursalDes(String sucursalDes) {
		this.sucursalDes = sucursalDes;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getOperaciones() {
		return operaciones;
	}
	public void setOperaciones(String operaciones) {
		this.operaciones = operaciones;
	}
	public String getDescOperaciones() {
		return descOperaciones;
	}
	public void setDescOperaciones(String descOperaciones) {
		this.descOperaciones = descOperaciones;
	}
}
