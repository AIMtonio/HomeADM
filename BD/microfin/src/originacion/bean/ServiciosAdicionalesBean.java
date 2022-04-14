package originacion.bean;

import general.bean.BaseBean;

import java.util.List;
import java.util.Map;

public class ServiciosAdicionalesBean extends BaseBean{
	
	private String servicioID;
	private String descripcion;
	private String validaDocs;
	private String tipoDocumento;
	private String institucionNominaID;
	private String productoCreditoID;
	private List<Integer> producCreditoID;
	private List<Integer> institNominaID;
	private Map <Integer,String> productoCreditoList;
	private Map <Integer,String> institNominaList;
	private String listaProductosCredito;
	private String listaEmpresas;
	private String estatus;

	//GETTERs y SETTERs 
	public String getServicioID(){
		return servicioID;
	}
	public void setServicioID(String servicioID){
		this.servicioID = servicioID;
	}
	public String getDescripcion(){
		return descripcion;
	}
	public void setDescripcion(String descripcion){
		this.descripcion = descripcion;
	}
	public String getValidaDocs(){
		return validaDocs;
	}
	public void setValidaDocs(String validaDocs){
		this.validaDocs = validaDocs;
	}
	public String getTipoDocumento(){
		return tipoDocumento;
	}
	public void setTipoDocumento(String tipoDocumento){
		this.tipoDocumento = tipoDocumento;
	}
	public List<Integer> getProducCreditoID(){
		return producCreditoID;
	}
	public void setProducCreditoID(List<Integer> producCreditoID){
		this.producCreditoID = producCreditoID;
	}
	public List<Integer> getInstitNominaID(){
		return  institNominaID;
	}
	public void setInstitNominaID(List<Integer> institNominaID){
		this.institNominaID = institNominaID;
	}
	
	public Map <Integer,String> getproductoCreditoList(){
		return productoCreditoList;
	}
	public void setProducCreditoID(Map <Integer,String> productoCreditoList){
		this.productoCreditoList = productoCreditoList;
	}
	
	public Map <Integer,String> getinstitNominaList(){
		return institNominaList;
	}
	public void setinstitNominaList (Map <Integer,String> institNominaList){
		this.institNominaList = institNominaList ;
	}
	public String getListaProductosCredito() {
		return listaProductosCredito;
	}
	public void setListaProductosCredito(String listaProductosCredito) {
		this.listaProductosCredito = listaProductosCredito;
	}
	public String getListaEmpresas() {
		return listaEmpresas;
	}
	public void setListaEmpresas(String listaEmpresas) {
		this.listaEmpresas = listaEmpresas;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getInstitucionNominaID() {
		return institucionNominaID;
	}
	public void setInstitucionNominaID(String institucionNominaID) {
		this.institucionNominaID = institucionNominaID;
	}
	public String getProductoCreditoID() {
		return productoCreditoID;
	}
	public void setProductoCreditoID(String productoCreditoID) {
		this.productoCreditoID = productoCreditoID;
	}
	
}
