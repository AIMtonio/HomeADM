package credito.bean;

import general.bean.BaseBean;

public class SubCtaSubClasifCartBean extends BaseBean{
		private String conceptoCarID;
		private String productoCartID;
		private String subCuenta;
		
		
		public String getConceptoCarID() {
			return conceptoCarID;
		}
		public void setConceptoCarID(String conceptoCarID) {
			this.conceptoCarID = conceptoCarID;
		}
		public String getSubCuenta() {
			return subCuenta;
		}
		public void setSubCuenta(String subCuenta) {
			this.subCuenta = subCuenta;
		}
		public String getProductoCartID() {
			return productoCartID;
		}
		public void setProductoCartID(String productoCartID) {
			this.productoCartID = productoCartID;
		}
}
