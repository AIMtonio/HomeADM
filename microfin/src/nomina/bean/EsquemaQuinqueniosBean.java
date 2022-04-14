package nomina.bean;

import general.bean.BaseBean;

import java.util.List;

public class EsquemaQuinqueniosBean extends BaseBean{
	
	// Declaración de Atributos
	
		private String institNominaID;
		private String convenioNominaID;
		private String sucursalID;
		private String quinquenioID;
		private String plazoID;
		private String esqQuinquenioID;
		private String empresaID;
		private String clienteID;
		private String desQuinquenio;
		private String desplazo;
		private String manejaQuinquenios;
		private String cantidad;
		
		private List<String> lisSucursalID;
		private List<String> lisQuinquenioID;
		private List<String> lisPlazoID;
		
		
		// =========== GETTER & SETTER =========== //

		public String getInstitNominaID() {
			return institNominaID;
		}
		public void setInstitNominaID(String institNominaID) {
			this.institNominaID = institNominaID;
		}
		public String getConvenioNominaID() {
			return convenioNominaID;
		}
		public void setConvenioNominaID(String convenioNominaID) {
			this.convenioNominaID = convenioNominaID;
		}
		public String getSucursalID() {
			return sucursalID;
		}
		public void setSucursalID(String sucursalID) {
			this.sucursalID = sucursalID;
		}
		public String getQuinquenioID() {
			return quinquenioID;
		}
		public void setQuinquenioID(String quinquenioID) {
			this.quinquenioID = quinquenioID;
		}
		public String getPlazoID() {
			return plazoID;
		}
		public void setPlazoID(String plazoID) {
			this.plazoID = plazoID;
		}
		public List<String> getLisSucursalID() {
			return lisSucursalID;
		}
		public void setLisSucursalID(List<String> lisSucursalID) {
			this.lisSucursalID = lisSucursalID;
		}
		public List<String> getLisQuinquenioID() {
			return lisQuinquenioID;
		}
		public void setLisQuinquenioID(List<String> lisQuinquenioID) {
			this.lisQuinquenioID = lisQuinquenioID;
		}
		public List<String> getLisPlazoID() {
			return lisPlazoID;
		}
		public void setLisPlazoID(List<String> lisPlazoID) {
			this.lisPlazoID = lisPlazoID;
		}
		public String getEsqQuinquenioID() {
			return esqQuinquenioID;
		}
		public void setEsqQuinquenioID(String esqQuinquenioID) {
			this.esqQuinquenioID = esqQuinquenioID;
		}
		public String getEmpresaID() {
			return empresaID;
		}
		public void setEmpresaID(String empresaID) {
			this.empresaID = empresaID;
		}
		public String getClienteID() {
			return clienteID;
		}
		public void setClienteID(String clienteID) {
			this.clienteID = clienteID;
		}
		public String getDesQuinquenio() {
			return desQuinquenio;
		}
		public void setDesQuinquenio(String desQuinquenio) {
			this.desQuinquenio = desQuinquenio;
		}
		public String getDesplazo() {
			return desplazo;
		}
		public void setDesplazo(String desplazo) {
			this.desplazo = desplazo;
		}
		public String getManejaQuinquenios() {
			return manejaQuinquenios;
		}
		public void setManejaQuinquenios(String manejaQuinquenios) {
			this.manejaQuinquenios = manejaQuinquenios;
		}
		public String getCantidad() {
			return cantidad;
		}
		public void setCantidad(String cantidad) {
			this.cantidad = cantidad;
		}
		

}
