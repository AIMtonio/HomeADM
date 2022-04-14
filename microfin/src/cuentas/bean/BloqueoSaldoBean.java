package cuentas.bean;
import java.util.List;

import general.bean.BaseBean;
public class BloqueoSaldoBean extends BaseBean{
	
	//Declaracion de Constantes
	public static String  BLOQUEAR_SI = "S" ;
	public static String  BLOQUEAR_NO = "N" ;
	public static String  TIPO_BLOQUEOAUTOMATICO = "13";
	public static String  TIPO_REVERSABLOQAUTOTIPOCTA = "14";		//  Reversa de bloqueo Automatico por tipo de Cuenta TIPOSBLOQUEOS
	public static String  NAT_BLOQUEO= "B";
	public static String  NAT_DESBLOQUEO = "D";
	public static String  DESCRI_BLOQUEOAUTOMATICO   = "DEPOSITO A CUENTA";
	public static String  DESCRI_DESBLOQREVDEPACTA   = "REVERSA DEPOSITO A CUENTA";
	public static String  DESCRI_BLOQUEOAUTPAGOREM   = "BLOQUEO AUT. PAGO REMESAS";
	public static String  DESCRI_BLOQUEOAUTPAGOPORT  = "BLOQUEO AUT. PAGO OPORTUNIDADES";
	public static String  DESCRI_BLOQUEOAUTAPLDOCSBC = "BLOQUEO AUT. APLICACIÓN DOC. SBC";
	public static String  DESCRI_BLOQUEOAUTTRANSCTA	 = "BLOQUEO AUT. TRANSFERENCIA ENTRE CUENTAS";
	public static String  DESCRI_BLOQUEOAUTCHEQUE	 = "BLOQUEO AUT. DEPOSITO CHEQUE EN FIRME";
	//Atributos
	private String bloqueoID;
	private String fecha;
	private String clienteID;
	private String natMovimiento;
	private String cuentaAhoID;
	private String fechaMov;
	private String montoBloq;
	private String fechaDesbloq;
	private String tiposBloqID;
	private String descripcion;
	private String referencia;
	private String usuarioIDAuto;
	private String claveUsuAuto;
	private String contraseniaUsu;
	
	private String sucursalID;
	private String nombreInstitucion;
	private String nombreUsuario;
	private String nombreSucursal;
	private String nombreCliente;
	private String claveUsuario;
	private String fechaEmision;
	private String hora;
	private String motivoBloqueo;
	private String descripcionBloq;
	private String cajaID;
	
	private List tiposBloqueoID;
	private List lcuentaAho;
	private List lsaldoDispo;
	private List lsaldoBloq;
	private List lsaldoSBC;
	private List ldescripcion;
	private List lmonto;
	private List lreferencia;
	
	public String getBloqueoID() {
		return bloqueoID;
	}
	public void setBloqueoID(String bloqueoID) {
		this.bloqueoID = bloqueoID;
	}
	public String getNatMovimiento() {
		return natMovimiento;
	}
	public void setNatMovimiento(String natMovimiento) {
		this.natMovimiento = natMovimiento;
	}
	public String getCuentaAhoID() {
		return cuentaAhoID;
	}
	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}
	public String getFechaMov() {
		return fechaMov;
	}
	public void setFechaMov(String fechaMov) {
		this.fechaMov = fechaMov;
	}
	public String getMontoBloq() {
		return montoBloq;
	}
	public void setMontoBloq(String montoBloq) {
		this.montoBloq = montoBloq;
	}
	public String getFechaDesbloq() {
		return fechaDesbloq;
	}
	public void setFechaDesbloq(String fechaDesbloq) {
		this.fechaDesbloq = fechaDesbloq;
	}
	public String getTiposBloqID() {
		return tiposBloqID;
	}
	public void setTiposBloqID(String tiposBloqID) {
		this.tiposBloqID = tiposBloqID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getReferencia() {
		return referencia;
	}
	public void setReferencia(String referencia) {
		this.referencia = referencia;
	}
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public List getTiposBloqueoID() {
		return tiposBloqueoID;
	}
	public void setTiposBloqueoID(List tiposBloqueoID) {
		this.tiposBloqueoID = tiposBloqueoID;
	}
	public List getLcuentaAho() {
		return lcuentaAho;
	}
	public void setLcuentaAho(List lcuentaAho) {
		this.lcuentaAho = lcuentaAho;
	}
	public List getLsaldoDispo() {
		return lsaldoDispo;
	}
	public void setLsaldoDispo(List lsaldoDispo) {
		this.lsaldoDispo = lsaldoDispo;
	}
	public List getLsaldoBloq() {
		return lsaldoBloq;
	}
	public void setLsaldoBloq(List lsaldoBloq) {
		this.lsaldoBloq = lsaldoBloq;
	}
	public List getLsaldoSBC() {
		return lsaldoSBC;
	}
	public void setLsaldoSBC(List lsaldoSBC) {
		this.lsaldoSBC = lsaldoSBC;
	}
	public List getLdescripcion() {
		return ldescripcion;
	}
	public void setLdescripcion(List ldescripcion) {
		this.ldescripcion = ldescripcion;
	}
	public List getLmonto() {
		return lmonto;
	}
	public void setLmonto(List lmonto) {
		this.lmonto = lmonto;
	}
	public String getUsuarioIDAuto() {
		return usuarioIDAuto;
	}
	public void setUsuarioIDAuto(String usuarioIDAuto) {
		this.usuarioIDAuto = usuarioIDAuto;
	}
	public String getClaveUsuAuto() {
		return claveUsuAuto;
	}
	public void setClaveUsuAuto(String claveUsuAuto) {
		this.claveUsuAuto = claveUsuAuto;
	}
	public String getContraseniaUsu() {
		return contraseniaUsu;
	}
	public void setContraseniaUsu(String contraseniaUsu) {
		this.contraseniaUsu = contraseniaUsu;
	}
	public List getLreferencia() {
		return lreferencia;
	}
	public void setLreferencia(List lreferencia) {
		this.lreferencia = lreferencia;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getNombreUsuario() {
		return nombreUsuario;
	}
	public void setNombreUsuario(String nombreUsuario) {
		this.nombreUsuario = nombreUsuario;
	}
	public String getNombreSucursal() {
		return nombreSucursal;
	}
	public void setNombreSucursal(String nombreSucursal) {
		this.nombreSucursal = nombreSucursal;
	}
	public String getNombreCliente() {
		return nombreCliente;
	}
	public void setNombreCliente(String nombreCliente) {
		this.nombreCliente = nombreCliente;
	}
	public String getClaveUsuario() {
		return claveUsuario;
	}
	public void setClaveUsuario(String claveUsuario) {
		this.claveUsuario = claveUsuario;
	}
	public String getFechaEmision() {
		return fechaEmision;
	}
	public void setFechaEmision(String fechaEmision) {
		this.fechaEmision = fechaEmision;
	}
	public String getHora() {
		return hora;
	}
	public void setHora(String hora) {
		this.hora = hora;
	}
	public String getMotivoBloqueo() {
		return motivoBloqueo;
	}
	public void setMotivoBloqueo(String motivoBloqueo) {
		this.motivoBloqueo = motivoBloqueo;
	}
	public String getDescripcionBloq() {
		return descripcionBloq;
	}
	public void setDescripcionBloq(String descripcionBloq) {
		this.descripcionBloq = descripcionBloq;
	}
	public String getCajaID() {
		return cajaID;
	}
	public void setCajaID(String cajaID) {
		this.cajaID = cajaID;
	}


}
