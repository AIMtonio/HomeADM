package ventanilla.bean;
import general.bean.BaseBean;

public class SolSaldoSucursalBean extends BaseBean{
	private String usuarioID;
	private String sucursalID;
	private String sucursalNom;
	private String fechaSistema;
	private String diaHabilAnt;
	private String canCreDesem;
	private String monCreDesem;
	private String canInverVenci;
	private String monInverVenci;
	private String canChequeEmi;
	private String monChequeEmi;
	private String canChequeIntReA;
	private String monChequeIntReA;
	private String canChequeIntRe;
	private String monChequeIntRe;
	private String saldosCP;
	private String saldosCA;
	private String fechaSol;
	private String hora;
	
	private String cuentas;
	private String montoSolicitado;
	private String comentarios;
	
	// Usadas para el reporte
	private String fechaIni;
	private String fechaFin;
	
	private String FechaReporte;
	private String NombreUsuario;
	private String HoraEmision;
	private String NombreInstitucion;
	private String NombreSucursal;
		
	public String getUsuarioID() {
		return usuarioID;
	}
	public void setUsuarioID(String usuarioID) {
		this.usuarioID = usuarioID;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getFechaSistema() {
		return fechaSistema;
	}
	public void setFechaSistema(String fechaSistema) {
		this.fechaSistema = fechaSistema;
	}
	public String getDiaHabilAnt() {
		return diaHabilAnt;
	}
	public void setDiaHabilAnt(String diaHabilAnt) {
		this.diaHabilAnt = diaHabilAnt;
	}
	public String getCanCreDesem() {
		return canCreDesem;
	}
	public void setCanCreDesem(String canCreDesem) {
		this.canCreDesem = canCreDesem;
	}
	public String getMonCreDesem() {
		return monCreDesem;
	}
	public void setMonCreDesem(String monCreDesem) {
		this.monCreDesem = monCreDesem;
	}
	public String getCanInverVenci() {
		return canInverVenci;
	}
	public void setCanInverVenci(String canInverVenci) {
		this.canInverVenci = canInverVenci;
	}
	public String getMonInverVenci() {
		return monInverVenci;
	}
	public void setMonInverVenci(String monInverVenci) {
		this.monInverVenci = monInverVenci;
	}
	public String getCanChequeEmi() {
		return canChequeEmi;
	}
	public void setCanChequeEmi(String canChequeEmi) {
		this.canChequeEmi = canChequeEmi;
	}
	public String getMonChequeEmi() {
		return monChequeEmi;
	}
	public void setMonChequeEmi(String monChequeEmi) {
		this.monChequeEmi = monChequeEmi;
	}
	public String getCanChequeIntReA() {
		return canChequeIntReA;
	}
	public void setCanChequeIntReA(String anChequeIntReA) {
		this.canChequeIntReA = anChequeIntReA;
	}
	public String getMonChequeIntReA() {
		return monChequeIntReA;
	}
	public void setMonChequeIntReA(String monChequeIntReA) {
		this.monChequeIntReA = monChequeIntReA;
	}
	public String getCanChequeIntRe() {
		return canChequeIntRe;
	}
	public void setCanChequeIntRe(String canChequeIntRe) {
		this.canChequeIntRe = canChequeIntRe;
	}
	public String getMonChequeIntRe() {
		return monChequeIntRe;
	}
	public void setMonChequeIntRe(String monChequeIntRe) {
		this.monChequeIntRe = monChequeIntRe;
	}
	public String getSaldosCP() {
		return saldosCP;
	}
	public void setSaldosCP(String saldosCP) {
		this.saldosCP = saldosCP;
	}
	public String getSaldosCA() {
		return saldosCA;
	}
	public void setSaldosCA(String saldosCA) {
		this.saldosCA = saldosCA;
	}
	public String getMontoSolicitado() {
		return montoSolicitado;
	}
	public void setMontoSolicitado(String montoSolicitado) {
		this.montoSolicitado = montoSolicitado;
	}
	public String getComentarios() {
		return comentarios;
	}
	public void setComentarios(String comentarios) {
		this.comentarios = comentarios;
	}
	public String getFechaIni() {
		return fechaIni;
	}
	public void setFechaIni(String fechaIni) {
		this.fechaIni = fechaIni;
	}
	public String getFechaFin() {
		return fechaFin;
	}
	public void setFechaFin(String fechaFin) {
		this.fechaFin = fechaFin;
	}
	public String getFechaSol() {
		return fechaSol;
	}
	public void setFechaSol(String fechaSol) {
		this.fechaSol = fechaSol;
	}
	public String getHora() {
		return hora;
	}
	public void setHora(String hora) {
		this.hora = hora;
	}
	public String getFechaReporte() {
		return FechaReporte;
	}
	public void setFechaReporte(String fechaReporte) {
		FechaReporte = fechaReporte;
	}
	public String getNombreUsuario() {
		return NombreUsuario;
	}
	public void setNombreUsuario(String nombreUsuario) {
		NombreUsuario = nombreUsuario;
	}
	public String getHoraEmision() {
		return HoraEmision;
	}
	public void setHoraEmision(String horaEmision) {
		HoraEmision = horaEmision;
	}
	public String getNombreInstitucion() {
		return NombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		NombreInstitucion = nombreInstitucion;
	}
	public String getNombreSucursal() {
		return NombreSucursal;
	}
	public void setNombreSucursal(String nombreSucursal) {
		NombreSucursal = nombreSucursal;
	}
	public String getSucursalNom() {
		return sucursalNom;
	}
	public void setSucursalNom(String sucursalNom) {
		this.sucursalNom = sucursalNom;
	}
	public String getCuentas() {
		return cuentas;
	}
	public void setCuentas(String cuentas) {
		this.cuentas = cuentas;
	}
	
	
	
	
}
