package tesoreria.bean;

import general.bean.BaseBean;

public class RepEstatusCtaSantanderBean extends BaseBean{

		private String fechaInicio;
		private String fechaFin;
		private String estatus;
		private String solicutudCreditoID;
		private String sucursalID;
		private String presentacion;
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
		public String getEstatus() {
			return estatus;
		}
		public void setEstatus(String estatus) {
			this.estatus = estatus;
		}
		public String getSolicutudCreditoID() {
			return solicutudCreditoID;
		}
		public void setSolicutudCreditoID(String solicutudCreditoID) {
			this.solicutudCreditoID = solicutudCreditoID;
		}
		public String getSucursalID() {
			return sucursalID;
		}
		public void setSucursalID(String sucursalID) {
			this.sucursalID = sucursalID;
		}
		public String getPresentacion() {
			return presentacion;
		}
		public void setPresentacion(String presentacion) {
			this.presentacion = presentacion;
		}
		
		
		
}
