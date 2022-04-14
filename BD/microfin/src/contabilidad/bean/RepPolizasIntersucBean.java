package contabilidad.bean;

import general.bean.BaseBean;

import java.util.Date;


public class RepPolizasIntersucBean extends BaseBean {
	// Filtros
	private String fechaInicial;
	private String fechaFinal;
	private String tipoReporte;

	//Encabezados
	private String claveUsuario;
	private String fechaEmision;
	private String horaEmision;
	private String nombreInstitucion;
	
	//Auxiliales para todos los reportes
	private String sucursalOrigen;
	private String ccostosOrigen;
	private String sucursaldestino;
	private String ccostoDestino;
	private String fecha;
	private String tipoRegistro;
	
	//Auxiliares para el reporte de Transferencias entre Cuentas Bancarias	
	private double montosTranfer;	
	
	//Auxiliares para reporte de Polizas intersucursales
	private double cantidad;
	
	//Auxiliares para reporte de Factura Proveedores
	private String ccostoscxp;
	private String sucursalGasto;
	private String ccostoGasto;
	private double montoPagado;	
	
	//Auxiliares para reporte Gastos por comprobar y anticipo de sueldos
	private String sucOperacion;
	private String ccostoOperacion;
	private String movEmpleadosOperacion;
	private String ccostoEmpleado;
	private double salida;
	private double entrada;
	
	//Auxiliares para reporte de Operaciones en ventanilla socios
	private String centroOperacion;
	private String movimientosSocio;
	private String ccostosocio;
	public String getFechaInicial() {
		return fechaInicial;
	}
	public void setFechaInicial(String fechaInicial) {
		this.fechaInicial = fechaInicial;
	}
	public String getFechaFinal() {
		return fechaFinal;
	}
	public void setFechaFinal(String fechaFinal) {
		this.fechaFinal = fechaFinal;
	}
	public String getTipoReporte() {
		return tipoReporte;
	}
	public void setTipoReporte(String tipoReporte) {
		this.tipoReporte = tipoReporte;
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
	public String getHoraEmision() {
		return horaEmision;
	}
	public void setHoraEmision(String horaEmision) {
		this.horaEmision = horaEmision;
	}
	public String getSucursalOrigen() {
		return sucursalOrigen;
	}
	public void setSucursalOrigen(String sucursalOrigen) {
		this.sucursalOrigen = sucursalOrigen;
	}
	public String getCcostosOrigen() {
		return ccostosOrigen;
	}
	public void setCcostosOrigen(String ccostosOrigen) {
		this.ccostosOrigen = ccostosOrigen;
	}
	public String getSucursaldestino() {
		return sucursaldestino;
	}
	public void setSucursaldestino(String sucursaldestino) {
		this.sucursaldestino = sucursaldestino;
	}
	public String getCcostoDestino() {
		return ccostoDestino;
	}
	public void setCcostoDestino(String ccostoDestino) {
		this.ccostoDestino = ccostoDestino;
	}
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	public String getTipoRegistro() {
		return tipoRegistro;
	}
	public void setTipoRegistro(String tipoRegistro) {
		this.tipoRegistro = tipoRegistro;
	}
	public double getMontosTranfer() {
		return montosTranfer;
	}
	public void setMontosTranfer(double montosTranfer) {
		this.montosTranfer = montosTranfer;
	}
	public double getCantidad() {
		return cantidad;
	}
	public void setCantidad(double cantidad) {
		this.cantidad = cantidad;
	}
	public String getCcostoscxp() {
		return ccostoscxp;
	}
	public void setCcostoscxp(String ccostoscxp) {
		this.ccostoscxp = ccostoscxp;
	}
	public String getSucursalGasto() {
		return sucursalGasto;
	}
	public void setSucursalGasto(String sucursalGasto) {
		this.sucursalGasto = sucursalGasto;
	}
	public String getCcostoGasto() {
		return ccostoGasto;
	}
	public void setCcostoGasto(String ccostoGasto) {
		this.ccostoGasto = ccostoGasto;
	}
	public double getMontoPagado() {
		return montoPagado;
	}
	public void setMontoPagado(double montoPagado) {
		this.montoPagado = montoPagado;
	}
	public String getSucOperacion() {
		return sucOperacion;
	}
	public void setSucOperacion(String sucOperacion) {
		this.sucOperacion = sucOperacion;
	}
	public String getCcostoOperacion() {
		return ccostoOperacion;
	}
	public void setCcostoOperacion(String ccostoOperacion) {
		this.ccostoOperacion = ccostoOperacion;
	}
	public String getMovEmpleadosOperacion() {
		return movEmpleadosOperacion;
	}
	public void setMovEmpleadosOperacion(String movEmpleadosOperacion) {
		this.movEmpleadosOperacion = movEmpleadosOperacion;
	}
	public String getCcostoEmpleado() {
		return ccostoEmpleado;
	}
	public void setCcostoEmpleado(String ccostoEmpleado) {
		this.ccostoEmpleado = ccostoEmpleado;
	}
	public double getSalida() {
		return salida;
	}
	public void setSalida(double salida) {
		this.salida = salida;
	}
	public double getEntrada() {
		return entrada;
	}
	public void setEntrada(double entrada) {
		this.entrada = entrada;
	}
	public String getCentroOperacion() {
		return centroOperacion;
	}
	public void setCentroOperacion(String centroOperacion) {
		this.centroOperacion = centroOperacion;
	}
	public String getMovimientosSocio() {
		return movimientosSocio;
	}
	public void setMovimientosSocio(String movimientosSocio) {
		this.movimientosSocio = movimientosSocio;
	}
	public String getCcostosocio() {
		return ccostosocio;
	}
	public void setCcostosocio(String ccostosocio) {
		this.ccostosocio = ccostosocio;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	
	
	
}
