package nomina.bean;


import java.util.List;

import general.bean.BaseBean;

public class TipoEmpleadosConvenioBean  extends BaseBean{
	private String institNominaID;
	private String convenioNominaID;
	private String descripcion;
	private String sinTratamiento;
	private String conTratamiento;
	private String tipoEmpleadoID;
	private String seleccionado;
	private List listaTipoEmpleadoID;
	private List listaSinTratamiento;
	private List listaConTratamiento;
	private List listaSeleccionado;
	
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
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getSinTratamiento() {
		return sinTratamiento;
	}
	public void setSinTratamiento(String sinTratamiento) {
		this.sinTratamiento = sinTratamiento;
	}
	public String getConTratamiento() {
		return conTratamiento;
	}
	public void setConTratamiento(String conTratamiento) {
		this.conTratamiento = conTratamiento;
	}
	
	public String getTipoEmpleadoID() {
		return tipoEmpleadoID;
	}
	public void setTipoEmpleadoID(String tipoEmpleadoID) {
		this.tipoEmpleadoID = tipoEmpleadoID;
	}
	
	public String getSeleccionado() {
		return seleccionado;
	}
	public void setSeleccionado(String seleccionado) {
		this.seleccionado = seleccionado;
	}
	public List getListaTipoEmpleadoID() {
		return listaTipoEmpleadoID;
	}
	public void setListaTipoEmpleadoID(List listaTipoEmpleadoID) {
		this.listaTipoEmpleadoID = listaTipoEmpleadoID;
	}
	public List getListaSinTratamiento() {
		return listaSinTratamiento;
	}
	public void setListaSinTratamiento(List listaSinTratamiento) {
		this.listaSinTratamiento = listaSinTratamiento;
	}
	public List getListaConTratamiento() {
		return listaConTratamiento;
	}
	public void setListaConTratamiento(List listaConTratamiento) {
		this.listaConTratamiento = listaConTratamiento;
	}
	public List getListaSeleccionado() {
		return listaSeleccionado;
	}
	public void setListaSeleccionado(List listaSeleccionado) {
		this.listaSeleccionado = listaSeleccionado;
	}
	
	
	
}
