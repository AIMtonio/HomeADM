package seguimiento.bean;

import general.bean.BaseBean;

public class FormatoSeguimientoBean extends BaseBean{
	//Variables para reporte
		private String fechaInicio;
		private String fechaFin;
		private String categoriaID;
		private String sucursalID;
		private String gestorID;
		
		private String categoriaDesc;
		private String sucursalDesc;
		private String gestorDesc;
		private String nomInstitucion;
		private String fechaEmision;
		private String nomUsuario;
		
		public String getFechaInicio() {
			return fechaInicio;
		}
		public void setFechaInicio(String fechaInicio) {
			this.fechaInicio = fechaInicio;
		}
		public String getFechaFin() {
			return fechaFin;
		}
		public void setFechaFin(String fechaFin) {
			this.fechaFin = fechaFin;
		}
		public String getCategoriaID() {
			return categoriaID;
		}
		public void setCategoriaID(String categoriaID) {
			this.categoriaID = categoriaID;
		}
		public String getSucursalID() {
			return sucursalID;
		}
		public void setSucursalID(String sucursalID) {
			this.sucursalID = sucursalID;
		}
		public String getGestorID() {
			return gestorID;
		}
		public void setGestorID(String gestorID) {
			this.gestorID = gestorID;
		}
		public String getCategoriaDesc() {
			return categoriaDesc;
		}
		public void setCategoriaDesc(String categoriaDesc) {
			this.categoriaDesc = categoriaDesc;
		}
		public String getSucursalDesc() {
			return sucursalDesc;
		}
		public void setSucursalDesc(String sucursalDesc) {
			this.sucursalDesc = sucursalDesc;
		}
		public String getGestorDesc() {
			return gestorDesc;
		}
		public void setGestorDesc(String gestorDesc) {
			this.gestorDesc = gestorDesc;
		}
		public String getNomInstitucion() {
			return nomInstitucion;
		}
		public void setNomInstitucion(String nomInstitucion) {
			this.nomInstitucion = nomInstitucion;
		}
		public String getFechaEmision() {
			return fechaEmision;
		}
		public void setFechaEmision(String fechaEmision) {
			this.fechaEmision = fechaEmision;
		}
		public String getNomUsuario() {
			return nomUsuario;
		}
		public void setNomUsuario(String nomUsuario) {
			this.nomUsuario = nomUsuario;
		}
	}