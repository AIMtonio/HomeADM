package nomina.bean;

import general.bean.BaseBean;

import org.springframework.web.multipart.commons.CommonsMultipartFile;

public class ProcAfiliaBajaCtaClabeBean extends BaseBean{
	
	// Definicion de Atributos
	
	private String tipo;
	private String folioAfiliacionID;
	private String clienteID;
	private String institucionID;
	private String cuentaClabe;
	
	private String afiliada;
	private String comentario;
	private String nombInstitucion;
	private String nombCliente;
	private String claveAfiliacion;
	
	private String numAfiliacionID;

	private CommonsMultipartFile file = null;
	
	/*Parametros auxiliares para subir archivos*/
	private String descripcion;
	private String nombreControl;
	private String consecutivoString;
	private String consecutivoInt;
	private int numero;
	
	private String NumError;
	private String DescError;
	private int LineaError;
	public int exitosos=0;
	public int fallidos=0;

	/* Atributos Lectura del Archivo de Recepcion de Afiliacion */
	
	private String accion;
	
	// ============ GETTER  & SETTER ============== //
	
	public String getTipo() {
		return tipo;
	}

	public void setTipo(String tipo) {
		this.tipo = tipo;
	}

	public String getFolioAfiliacionID() {
		return folioAfiliacionID;
	}

	public void setFolioAfiliacionID(String folioAfiliacionID) {
		this.folioAfiliacionID = folioAfiliacionID;
	}

	public String getClienteID() {
		return clienteID;
	}

	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}

	public String getInstitucionID() {
		return institucionID;
	}

	public void setInstitucionID(String institucionID) {
		this.institucionID = institucionID;
	}

	public String getCuentaClabe() {
		return cuentaClabe;
	}

	public void setCuentaClabe(String cuentaClabe) {
		this.cuentaClabe = cuentaClabe;
	}

	public String getAfiliada() {
		return afiliada;
	}

	public void setAfiliada(String afiliada) {
		this.afiliada = afiliada;
	}

	public String getComentario() {
		return comentario;
	}

	public void setComentario(String comentario) {
		this.comentario = comentario;
	}

	
	public String getNombInstitucion() {
		return nombInstitucion;
	}

	public void setNombInstitucion(String nombInstitucion) {
		this.nombInstitucion = nombInstitucion;
	}

	public String getNombCliente() {
		return nombCliente;
	}

	public void setNombCliente(String nombCliente) {
		this.nombCliente = nombCliente;
	}

	public String getClaveAfiliacion() {
		return claveAfiliacion;
	}

	public void setClaveAfiliacion(String claveAfiliacion) {
		this.claveAfiliacion = claveAfiliacion;
	}

	public String getNumAfiliacionID() {
		return numAfiliacionID;
	}

	public void setNumAfiliacionID(String numAfiliacionID) {
		this.numAfiliacionID = numAfiliacionID;
	}

	public CommonsMultipartFile getFile() {
		return file;
	}

	public void setFile(CommonsMultipartFile file) {
		this.file = file;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getNombreControl() {
		return nombreControl;
	}

	public void setNombreControl(String nombreControl) {
		this.nombreControl = nombreControl;
	}

	public String getConsecutivoString() {
		return consecutivoString;
	}

	public void setConsecutivoString(String consecutivoString) {
		this.consecutivoString = consecutivoString;
	}

	public String getConsecutivoInt() {
		return consecutivoInt;
	}

	public void setConsecutivoInt(String consecutivoInt) {
		this.consecutivoInt = consecutivoInt;
	}

	public int getNumero() {
		return numero;
	}

	public void setNumero(int numero) {
		this.numero = numero;
	}

	public String getNumError() {
		return NumError;
	}

	public void setNumError(String numError) {
		NumError = numError;
	}

	public String getDescError() {
		return DescError;
	}

	public void setDescError(String descError) {
		DescError = descError;
	}

	public int getLineaError() {
		return LineaError;
	}

	public void setLineaError(int lineaError) {
		LineaError = lineaError;
	}

	public String getAccion() {
		return accion;
	}

	public void setAccion(String accion) {
		this.accion = accion;
	}
	public int getExitosos() {
		return exitosos;
	}
	public void setExitosos(int exitosos) {
		this.exitosos = exitosos;
	}
	public int getFallidos() {
		return fallidos;
	}
	public void setFallidos(int fallidos) {
		this.fallidos = fallidos;
	}
}
