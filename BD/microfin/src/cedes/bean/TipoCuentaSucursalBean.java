package cedes.bean;
import java.util.List;
import general.bean.BaseBean;

public class TipoCuentaSucursalBean extends BaseBean{
	private String tipoCuentaID;
	private String sucursalID;
	private String plazaID;
	private String regionID;
	private String estadoID;
	
	private String descripcion;
	private String nombreSucursal;
	private String nombrePlaza;
	private String nombreRegion;
	private String nombreEstado;
	private String estatus;
	private String dirVentasID;
	private String subDireccionID;
	private String nombreSubDir;
	private String nombreDirVta; 
	
	/* Auxiliares*/
	private String sucursalAuxID;
	private String plazaAuxID;
	private String subDireccionAuxID;
	private String dirVentasAuxID;
	private String estadoAuxID;
	private String estatusAux;
	private String eliminar;
	private String instrumentoID;
	private String tipoInstrumentoID;
	
	
	public String getInstrumentoID() {
		return instrumentoID;
	}

	public void setInstrumentoID(String instrumentoID) {
		this.instrumentoID = instrumentoID;
	}

	public String getTipoInstrumentoID() {
		return tipoInstrumentoID;
	}

	public void setTipoInstrumentoID(String tipoInstrumentoID) {
		this.tipoInstrumentoID = tipoInstrumentoID;
	}

	public String getEliminar() {
		return eliminar;
	}

	public void setEliminar(String eliminar) {
		this.eliminar = eliminar;
	}

	public String getSucursalAuxID() {
		return sucursalAuxID;
	}

	public void setSucursalAuxID(String sucursalAuxID) {
		this.sucursalAuxID = sucursalAuxID;
	}

	public String getPlazaAuxID() {
		return plazaAuxID;
	}

	public void setPlazaAuxID(String plazaAuxID) {
		this.plazaAuxID = plazaAuxID;
	}

	public String getSubDireccionAuxID() {
		return subDireccionAuxID;
	}

	public void setSubDireccionAuxID(String subDireccionAuxID) {
		this.subDireccionAuxID = subDireccionAuxID;
	}

	public String getDirVentasAuxID() {
		return dirVentasAuxID;
	}

	public void setDirVentasAuxID(String dirVentasAuxID) {
		this.dirVentasAuxID = dirVentasAuxID;
	}

	public String getEstadoAuxID() {
		return estadoAuxID;
	}

	public void setEstadoAuxID(String estadoAuxID) {
		this.estadoAuxID = estadoAuxID;
	}

	public String getEstatusAux() {
		return estatusAux;
	}

	public void setEstatusAux(String estatusAux) {
		this.estatusAux = estatusAux;
	}

	public String getNombreSubDir() {
		return nombreSubDir;
	}

	public void setNombreSubDir(String nombreSubDir) {
		this.nombreSubDir = nombreSubDir;
	}

	public String getNombreDirVta() {
		return nombreDirVta;
	}

	public void setNombreDirVta(String nombreDirVta) {
		this.nombreDirVta = nombreDirVta;
	}

	public String getDirVentasID() {
		return dirVentasID;
	}

	public void setDirVentasID(String dirVentasID) {
		this.dirVentasID = dirVentasID;
	}

	public String getSubDireccionID() {
		return subDireccionID;
	}

	public void setSubDireccionID(String subDireccionID) {
		this.subDireccionID = subDireccionID;
	}

	/* Auxiliares para Grid */
	private List lSucursalID;
	private List lPlazaID;
	private List lRegionID;
	private List lEstadoID;
	private List lEstatus;
	private String tipoLista;



	private List lSubDireccionID;
	private List lDirVentasID;
	
	/*Parametros de Auditoria*/
	private String empresaID;
	private String usuario;
	private String fechaActual;  
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	
	/*Auxiliares para reporte*/
	private String nombreCuenta;
	private String nombreInstitucion;
	private String fechaSistema; 
	private String nombreUsuario; 
    

    
	public String getTipoCuentaID() {
		return tipoCuentaID;
	}

	public void setTipoCuentaID(String tipoCuentaID) {
		this.tipoCuentaID = tipoCuentaID;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getSucursalID() {
		return sucursalID;
	}

	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}

	public String getNombreSucursal() {
		return nombreSucursal;
	}

	public void setNombreSucursal(String nombreSucursal) {
		this.nombreSucursal = nombreSucursal;
	}
	public String getNombreRegion() {
		return nombreRegion;
	}

	public void setNombreRegion(String nombreRegion) {
		this.nombreRegion = nombreRegion;
	}

	public String getNombreEstado() {
		return nombreEstado;
	}

	public void setNombreEstado(String nombreEstado) {
		this.nombreEstado = nombreEstado;
	}

	public String getEmpresaID() {
		return empresaID;
	}

	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}

	public String getUsuario() {
		return usuario;
	}

	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}

	public String getSucursal() {
		return sucursal;
	}

	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
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

	public String getNumTransaccion() {
		return numTransaccion;
	}

	public void setNumTransaccion(String numTransaccion) {
		this.numTransaccion = numTransaccion;
	}

	public String getEstatus() {
		return estatus;
	}

	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}

	public String getPlazaID() {
		return plazaID;
	}

	public void setPlazaID(String plazaID) {
		this.plazaID = plazaID;
	}

	public String getRegionID() {
		return regionID;
	}

	public void setRegionID(String regionID) {
		this.regionID = regionID;
	}

	public String getEstadoID() {
		return estadoID;
	}

	public void setEstadoID(String estadoID) {
		this.estadoID = estadoID;
	}

	public String getNombrePlaza() {
		return nombrePlaza;
	}

	public void setNombrePlaza(String nombrePlaza) {
		this.nombrePlaza = nombrePlaza;
	}

	public List getlSucursalID() {
		return lSucursalID;
	}

	public void setlSucursalID(List lSucursalID) {
		this.lSucursalID = lSucursalID;
	}

	public List getlPlazaID() {
		return lPlazaID;
	}

	public void setlPlazaID(List lPlazaID) {
		this.lPlazaID = lPlazaID;
	}

	public List getlRegionID() {
		return lRegionID;
	}

	public void setlRegionID(List lRegionID) {
		this.lRegionID = lRegionID;
	}

	public List getlEstadoID() {
		return lEstadoID;
	}

	public void setlEstadoID(List lEstadoID) {
		this.lEstadoID = lEstadoID;
	}

	public List getlEstatus() {
		return lEstatus;
	}

	public void setlEstatus(List lEstatus) {
		this.lEstatus = lEstatus;
	}

	public List getlSubDireccionID() {
		return lSubDireccionID;
	}

	public void setlSubDireccionID(List lSubDireccionID) {
		this.lSubDireccionID = lSubDireccionID;
	}

	public List getlDirVentasID() {
		return lDirVentasID;
	}

	public void setlDirVentasID(List lDirVentasID) {
		this.lDirVentasID = lDirVentasID;
	}
	public String getNombreCuenta() {
		return nombreCuenta;
	}

	public void setNombreCuenta(String nombreCuenta) {
		this.nombreCuenta = nombreCuenta;
	}

	public String getNombreInstitucion() {
		return nombreInstitucion;
	}

	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}

	public String getFechaSistema() {
		return fechaSistema;
	}

	public void setFechaSistema(String fechaSistema) {
		this.fechaSistema = fechaSistema;
	}

	public String getNombreUsuario() {
		return nombreUsuario;
	}

	public void setNombreUsuario(String nombreUsuario) {
		this.nombreUsuario = nombreUsuario;
	} 

	public String getTipoLista() {
		return tipoLista;
	}

	public void setTipoLista(String tipoLista) {
		this.tipoLista = tipoLista;
	}

}
