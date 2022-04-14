package general.bean;

import java.sql.Date;
 

public class ParametrosAuditoriaBean extends BaseBean{
	
	private long numeroTransaccion;
	private int sucursal;	
	private int usuario;
	private String nombrePrograma;
	private String direccionIP;
	private Date fecha;
	private int empresaID;
	private String origenDatos;
	private String rutaReportes;
	private String rutaImgReportes;
	private String logoCtePantalla;
	
	public long getNumeroTransaccion() {
		return numeroTransaccion;
	}
	public void setNumeroTransaccion(long numeroTransaccion) {
		this.numeroTransaccion = numeroTransaccion;
	}
	public int getSucursal() {
		return sucursal;
	}
	public void setSucursal(int sucursal) {
		this.sucursal = sucursal;
	}
	public int getUsuario() {
		return usuario;
	}
	public void setUsuario(int usuario) {
		this.usuario = usuario;
	}
	public String getNombrePrograma() {
		return nombrePrograma;
	}
	public void setNombrePrograma(String nombrePrograma) {
		this.nombrePrograma = nombrePrograma;
	}
	public String getDireccionIP() {
		return direccionIP;
	}
	public void setDireccionIP(String direccionIP) {
		this.direccionIP = direccionIP;
	}
	public Date getFecha() {
		return fecha;
	}
	public void setFecha(Date fecha) {
		this.fecha = fecha;
	}
	public int getEmpresaID() {
		return empresaID;
	}
	public void setEmpresaID(int empresaID) {
		this.empresaID = empresaID;
	}
	public String getOrigenDatos() {
		return origenDatos;
	}
	public void setOrigenDatos(String origenDatos) {
		this.origenDatos = origenDatos;
	}
	public String getRutaReportes() {
		return rutaReportes;
	}
	public void setRutaReportes(String rutaReportes) {
		this.rutaReportes = rutaReportes;
	}
	public String getRutaImgReportes() {
		return rutaImgReportes;
	}
	public void setRutaImgReportes(String rutaImgReportes) {
		this.rutaImgReportes = rutaImgReportes;
	}
	public String getLogoCtePantalla() {
		return logoCtePantalla;
	}
	public void setLogoCtePantalla(String logoCtePantalla) {
		this.logoCtePantalla = logoCtePantalla;
	}
	

	
}
