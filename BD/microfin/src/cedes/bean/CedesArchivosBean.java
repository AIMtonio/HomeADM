package cedes.bean;

	import general.bean.BaseBean;

	import org.springframework.web.multipart.MultipartFile;

	public class CedesArchivosBean extends BaseBean{
		 
		private MultipartFile file;
		private String cedeID;
		private String archivoCuentaID;
		private String tipoDocumento;
		private String consecutivo;
		private String observacion;
		private String recurso;
		private String comentario;
		private String usuario;
		private String fechaActual;
		private String direccionIP;
		private String programaID;
		private String sucursal;
		private String numTransaccion;
		private String empresaID;
		

		
		public MultipartFile getFile() {
			return file;
		}
		public void setFile(MultipartFile file) {
			this.file = file;
		}
		public String getCedeID() {
			return cedeID;
		}
		public void setCedeID(String cedeID) {
			this.cedeID = cedeID;
		}
		public String getArchivoCuentaID() {
			return archivoCuentaID;
		}
		public void setArchivoCuentaID(String archivoCuentaID) {
			this.archivoCuentaID = archivoCuentaID;
		}
		public String getTipoDocumento() {
			return tipoDocumento;
		}
		public void setTipoDocumento(String tipoDocumento) {
			this.tipoDocumento = tipoDocumento;
		}
		public String getConsecutivo() {
			return consecutivo;
		}
		public void setConsecutivo(String consecutivo) {
			this.consecutivo = consecutivo;
		}
		public String getObservacion() {
			return observacion;
		}
		public void setObservacion(String observacion) {
			this.observacion = observacion;
		}
		public String getRecurso() {
			return recurso;
		}
		public void setRecurso(String recurso) {
			this.recurso = recurso;
		}
		
		
		public String getComentario() {
			return comentario;
		}
		public void setComentario(String comentario) {
			this.comentario = comentario;
		}
		public String getUsuario() {
			return usuario;
		}
		public void setUsuario(String usuario) {
			this.usuario = usuario;
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
		public String getSucursal() {
			return sucursal;
		}
		public void setSucursal(String sucursal) {
			this.sucursal = sucursal;
		}
		public String getNumTransaccion() {
			return numTransaccion;
		}
		public void setNumTransaccion(String numTransaccion) {
			this.numTransaccion = numTransaccion;
		}

		 

	}

