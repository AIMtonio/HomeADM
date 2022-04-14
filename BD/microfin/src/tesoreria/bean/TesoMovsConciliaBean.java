package tesoreria.bean;

import java.util.List;

public class TesoMovsConciliaBean {
	private String folioCargaID; 
	private String institucionID;
	private String numCtaInstit;
	private String cuentaAhoID; 
	private String fechaCarga;
	private String natMovimiento;
	private String referenciaMov;
	private String status;
	private int existenMovsSelec;
	private String tipoMovTesoDes;
	
	private String numeroMov;
	private String fechaMov;
	private String descripcionMov;
	private String tipoMov;
	private String montoMov;
	private String fechaOperacion;
	private String descripcionMovE;
	private String tipoMovE;
	private String montoMovE;
	private String numeroMovE;
    private String totalConciliados;
       

    private String empresaID;
    private String usuario;
    private String fechaActual;
    private String direccionIP;
    private String programaID;
    private String sucursal;
    private String numTransaccion;
	
	private List listaConciliado;
	
	private List listaFolioCargaID; 
	private List listaNumeroMov;  
	private List listaFechaCarga;
	private List listaFechaOperacion;
	private List listaNatMovimiento;
	private List listaMontoMov;
	private List listaTipoMov;
	private List listaDescripcionMov;
	private List listaReferenciaMov;
	private List listaStatus; 
	private List listaCentroCosto; // centro de costos
	
	// Auxiliares para el boton de cierre de Movs. Internos
	private String listaFoliosMovs;
	private String listaFoliosCarga;
	
	// auxiliares del bean 
	private String cuentaContable;
	private String fechaSistema;
	private List listaCuentaContable; 
	private String cCostos; // Centro de Costos
	
	// Lista para el cierre de las conciliaciones
	private List<String> listaConciliaciones;
	
	public String getTotalConciliados() {
		return totalConciliados;
	}

	public void setTotalConciliados(String totalConciliados) {
		this.totalConciliados = totalConciliados;
	}

	public String getInstitucionID() {
		return institucionID;
	}

	public void setInstitucionID(String institucionID) {
		this.institucionID = institucionID;
	}

	public String getNumCtaInstit() {
		return numCtaInstit;
	}

	public void setNumCtaInstit(String numCtaInstit) {
		this.numCtaInstit = numCtaInstit;
	}

	public String getNumeroMov() {
		return numeroMov;
	}

	public void setNumeroMov(String numeroMov) {
		this.numeroMov = numeroMov;
	}

	public String getFechaMov() {
		return fechaMov;
	}

	public void setFechaMov(String fechaMov) {
		this.fechaMov = fechaMov;
	}

	public String getDescripcionMov() {
		return descripcionMov;
	}

	public void setDescripcionMov(String descripcionMov) {
		this.descripcionMov = descripcionMov;
	}

	public String getTipoMov() {
		return tipoMov;
	}

	public void setTipoMov(String tipoMov) {
		this.tipoMov = tipoMov;
	}

	public String getMontoMov() {
		return montoMov;
	}

	public void setMontoMov(String montoMov) {
		this.montoMov = montoMov;
	}

	public String getFechaOperacion() {
		return fechaOperacion;
	}

	public void setFechaOperacion(String fechaOperacion) {
		this.fechaOperacion = fechaOperacion;
	}

	public String getDescripcionMovE() {
		return descripcionMovE;
	}

	public void setDescripcionMovE(String descripcionMovE) {
		this.descripcionMovE = descripcionMovE;
	}

	public String getTipoMovE() {
		return tipoMovE;
	}

	public void setTipoMovE(String tipoMovE) {
		this.tipoMovE = tipoMovE;
	}

	public String getMontoMovE() {
		return montoMovE;
	}

	public void setMontoMovE(String montoMovE) {
		this.montoMovE = montoMovE;
	}

	public String getNumeroMovE() {
		return numeroMovE;
	}

	public void setNumeroMovE(String numeroMovE) {
		this.numeroMovE = numeroMovE;
	}

	public List getListaConciliado() {
		return listaConciliado;
	}

	public void setListaConciliado(List listaConciliado) {
		this.listaConciliado = listaConciliado;
	}

	public String getFolioCargaID() {
		return folioCargaID;
	}

	public void setFolioCargaID(String folioCargaID) {
		this.folioCargaID = folioCargaID;
	}

	public String getCuentaAhoID() {
		return cuentaAhoID;
	}

	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}

	public String getFechaCarga() {
		return fechaCarga;
	}

	public void setFechaCarga(String fechaCarga) {
		this.fechaCarga = fechaCarga;
	}

	public String getNatMovimiento() {
		return natMovimiento;
	}

	public void setNatMovimiento(String natMovimiento) {
		this.natMovimiento = natMovimiento;
	}

	public String getReferenciaMov() {
		return referenciaMov;
	}

	public void setReferenciaMov(String referenciaMov) {
		this.referenciaMov = referenciaMov;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
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

	public List getListaFolioCargaID() {
		return listaFolioCargaID;
	}

	public void setListaFolioCargaID(List listaFolioCargaID) {
		this.listaFolioCargaID = listaFolioCargaID;
	}

	public List getListaNumeroMov() {
		return listaNumeroMov;
	}

	public void setListaNumeroMov(List listaNumeroMov) {
		this.listaNumeroMov = listaNumeroMov;
	}

	public List getListaFechaCarga() {
		return listaFechaCarga;
	}

	public void setListaFechaCarga(List listaFechaCarga) {
		this.listaFechaCarga = listaFechaCarga;
	}

	public List getListaFechaOperacion() {
		return listaFechaOperacion;
	}

	public void setListaFechaOperacion(List listaFechaOperacion) {
		this.listaFechaOperacion = listaFechaOperacion;
	}

	public List getListaNatMovimiento() {
		return listaNatMovimiento;
	}

	public void setListaNatMovimiento(List listaNatMovimiento) {
		this.listaNatMovimiento = listaNatMovimiento;
	}

	public List getListaMontoMov() {
		return listaMontoMov;
	}

	public void setListaMontoMov(List listaMontoMov) {
		this.listaMontoMov = listaMontoMov;
	}

	public List getListaTipoMov() {
		return listaTipoMov;
	}

	public void setListaTipoMov(List listaTipoMov) {
		this.listaTipoMov = listaTipoMov;
	}

	public List getListaDescripcionMov() {
		return listaDescripcionMov;
	}

	public void setListaDescripcionMov(List listaDescripcionMov) {
		this.listaDescripcionMov = listaDescripcionMov;
	}

	public List getListaReferenciaMov() {
		return listaReferenciaMov;
	}

	public void setListaReferenciaMov(List listaReferenciaMov) {
		this.listaReferenciaMov = listaReferenciaMov;
	}

	public List getListaStatus() {
		return listaStatus;
	}

	public void setListaStatus(List listaStatus) {
		this.listaStatus = listaStatus;
	}

	public String getCuentaContable() {
		return cuentaContable;
	}

	public void setCuentaContable(String cuentaContable) {
		this.cuentaContable = cuentaContable;
	}

	public List getListaCuentaContable() {
		return listaCuentaContable;
	}

	public void setListaCuentaContable(List listaCuentaContable) {
		this.listaCuentaContable = listaCuentaContable;
	}

	public String getFechaSistema() {
		return fechaSistema;
	}

	public void setFechaSistema(String fechaSistema) {
		this.fechaSistema = fechaSistema;
	}

	public int getExistenMovsSelec() {
		return existenMovsSelec;
	}

	public void setExistenMovsSelec(int existenMovsSelec) {
		this.existenMovsSelec = existenMovsSelec;
	}

	public String getTipoMovTesoDes() {
		return tipoMovTesoDes;
	}

	public void setTipoMovTesoDes(String tipoMovTesoDes) {
		this.tipoMovTesoDes = tipoMovTesoDes;
	}

	public String getcCostos() {
		return cCostos;
	}

	public void setcCostos(String cCostos) {
		this.cCostos = cCostos;
	}

	public List getListaCentroCosto() {
		return listaCentroCosto;
	}

	public void setListaCentroCosto(List listaCentroCosto) {
		this.listaCentroCosto = listaCentroCosto;
	}

	public String getListaFoliosMovs() {
		return listaFoliosMovs;
	}

	public void setListaFoliosMovs(String listaFoliosMovs) {
		this.listaFoliosMovs = listaFoliosMovs;
	}

	public String getListaFoliosCarga() {
		return listaFoliosCarga;
	}

	public void setListaFoliosCarga(String listaFoliosCarga) {
		this.listaFoliosCarga = listaFoliosCarga;
	}

	public List<String> getListaConciliaciones() {
		return listaConciliaciones;
	}
	public void setListaConciliaciones(List<String> listaConciliaciones) {
		this.listaConciliaciones = listaConciliaciones;
	}
}
