package soporte.bean;
import org.springframework.web.multipart.MultipartFile;

import general.bean.BaseBean;

public class EdoCtaCertificadoBean extends BaseBean{
		private MultipartFile archivoKey;
		private MultipartFile archivoCer;
		private String rutaCompletaCer;
		private String rutaCompletaKey;
		private String contrasena;
		
		
		public MultipartFile getArchivoKey() {
			return archivoKey;
		}
		public void setArchivoKey(MultipartFile archivoKey) {
			this.archivoKey = archivoKey;
		}
		public MultipartFile getArchivoCer() {
			return archivoCer;
		}
		public void setArchivoCer(MultipartFile archivoCer) {
			this.archivoCer = archivoCer;
		}
		public String getRutaCompletaCer() {
			return rutaCompletaCer;
		}
		public void setRutaCompletaCer(String rutaCompletaCer) {
			this.rutaCompletaCer = rutaCompletaCer;
		}
		public String getRutaCompletaKey() {
			return rutaCompletaKey;
		}
		public void setRutaCompletaKey(String rutaCompletaKey) {
			this.rutaCompletaKey = rutaCompletaKey;
		}
		public String getContrasena() {
			return contrasena;
		}
		public void setContrasena(String contrasena) {
			this.contrasena = contrasena;
		}
			
}

