package tarjetas.bean;
import general.bean.BaseBean;
public class TarCredMovimientosBean extends BaseBean{

	private String tarjetaID;
	private String fechaInicio;
	private String fechaVencimiento;
	private String tipoOperacion;
	public static int LONGITUD_ID = 10;
	private String fechaEmision;
	private String nombreUsuario;
	private String nombreInstitucion;
	private String numeroReporte;
	// MOVIMIENTOS DE TARJETAS
	private String fechaFin;
	private String anioPeriodo;
	private String mesPeriodo;
	private String fechaOperacion;
	private String referencia;
	private String nombreComercio;
	private String cargos;
	private String abonos;
	
	
	
	public String getTarjetaID() {
		return tarjetaID;
	}
	public void setTarjetaID(String tarjetaID) {
		this.tarjetaID = tarjetaID;
	}
	
	public String getFechaInicio() {
		return fechaInicio;
	}
	public void setFechaInicio(String fechaInicio) {
		this.fechaInicio = fechaInicio;
	}
	public String getFechaVencimiento() {
		return fechaVencimiento;
	}
	public void setFechaVencimiento(String fechaVencimiento) {
		this.fechaVencimiento = fechaVencimiento;
	}
	public String getTipoOperacion() {
		return tipoOperacion;
	}
	public void setTipoOperacion(String tipoOperacion) {
		this.tipoOperacion = tipoOperacion;
	}
	public String getFechaEmision() {
		return fechaEmision;
	}
	public void setFechaEmision(String fechaEmision) {
		this.fechaEmision = fechaEmision;
	}
	public String getNombreUsuario() {
		return nombreUsuario;
	}
	public void setNombreUsuario(String nombreUsuario) {
		this.nombreUsuario = nombreUsuario;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getNumeroReporte() {
		return numeroReporte;
	}
	public void setNumeroReporte(String numeroReporte) {
		this.numeroReporte = numeroReporte;
	}
	public String getFechaFin() {
		return fechaFin;
	}
	public void setFechaFin(String fechaFin) {
		this.fechaFin = fechaFin;
	}
	public String getAnioPeriodo() {
		return anioPeriodo;
	}
	public void setAnioPeriodo(String anioPeriodo) {
		this.anioPeriodo = anioPeriodo;
	}
	public String getMesPeriodo() {
		return mesPeriodo;
	}
	public void setMesPeriodo(String mesPeriodo) {
		this.mesPeriodo = mesPeriodo;
	}
	public String getFechaOperacion() {
		return fechaOperacion;
	}
	public void setFechaOperacion(String fechaOperacion) {
		this.fechaOperacion = fechaOperacion;
	}
	public String getReferencia() {
		return referencia;
	}
	public void setReferencia(String referencia) {
		this.referencia = referencia;
	}
	public String getNombreComercio() {
		return nombreComercio;
	}
	public void setNombreComercio(String nombreComercio) {
		this.nombreComercio = nombreComercio;
	}
	public String getCargos() {
		return cargos;
	}
	public void setCargos(String cargos) {
		this.cargos = cargos;
	}
	public String getAbonos() {
		return abonos;
	}
	public void setAbonos(String abonos) {
		this.abonos = abonos;
	}
	
	
	
	
	
	
	
}
