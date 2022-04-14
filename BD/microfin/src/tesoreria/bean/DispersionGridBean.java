package tesoreria.bean;

import general.bean.BaseBean;

public class DispersionGridBean extends BaseBean{
	
	private String gridCuentaAhoID;
	private String gridNombreCte;
	private String gridDescripcion;
	private String gridReferencia;
	private String gridTipoMov;
	private String gridMonto;
	private String gridCuentaClabe; 
	private String gridRFC;
	private String gridEnviados;
	private String gridFechaEnvio;
	private String gridNombreBenefi;
	private String gridFormaPago;
	private String gridAnticipoPago;
	private String gridTipoChequera;
	private String gridConceptoDisp;
	private String gridTipoConcepto;
	
	/*Agregados para la seccion de Cheques */
	
	private String institucionID;
	private String cuentaAhorro; //  cuenta de la institucion
	private String sucursalID;
	private String usuarioID;
	private String clienteID;
	private String folioOperacion;
	private String codigoLayaut;
	private String concepto;
	private String correoBeneficiario;
	private String bancoReceptor;
	private String plazaBanxico;
	private String fechaAplicacion;
	private String claveSucursales;
	private String claveSucursal;
	private String tipoPago;
	
	/*Agregados para el leyaout de banorte*/
	
	private String numeroOrden;

	public String getInstitucionID() {
		return institucionID;
	}

	public void setInstitucionID(String institucionID) {
		this.institucionID = institucionID;
	}

	public String getCuentaAhorro() {
		return cuentaAhorro;
	}

	public void setCuentaAhorro(String cuentaAhorro) {
		this.cuentaAhorro = cuentaAhorro;
	}

	public String getSucursalID() {
		return sucursalID;
	}

	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}

	public String getUsuarioID() {
		return usuarioID;
	}

	public void setUsuarioID(String usuarioID) {
		this.usuarioID = usuarioID;
	}

	public String getGridAnticipoPago() {
		return gridAnticipoPago;
	}

	public void setGridAnticipoPago(String gridAnticipoPago) {
		this.gridAnticipoPago = gridAnticipoPago;
	}
	private String claveDispersion;
	private String iva;
	private String fechaAplicar;
	private String nombreBeneficiario;
	private String cuentaContable;
	private String descCtaContable;

	
	
	public String getDescCtaContable() {
		return descCtaContable;
	}

	public void setDescCtaContable(String descCtaContable) {
		this.descCtaContable = descCtaContable;
	}

	public String getCuentaContable() {
		return cuentaContable;
	}

	public void setCuentaContable(String cuentaContable) {
		this.cuentaContable = cuentaContable;
	}
		
	public String getGridFormaPago() {
		return gridFormaPago;
	}
	public void setGridFormaPago(String gridFormaPago) {
		this.gridFormaPago = gridFormaPago;
	}
	public String getGridFechaEnvio() {
		return gridFechaEnvio;
	}
	public void setGridFechaEnvio(String gridFechaEnvio) {
		this.gridFechaEnvio = gridFechaEnvio;
	}
	public String getGridNombreBenefi() {
		return gridNombreBenefi;
	}
	public void setGridNombreBenefi(String gridNombreBenefi) {
		this.gridNombreBenefi = gridNombreBenefi;
	}

	public String getGridCuentaAhoID() {
		return gridCuentaAhoID;
	}
	public void setGridCuentaAhoID(String gridCuentaAhoID) {
		this.gridCuentaAhoID = gridCuentaAhoID;
	}
	public String getGridNombreCte() {
		return gridNombreCte;
	}
	public void setGridNombreCte(String gridNombreCte) {
		this.gridNombreCte = gridNombreCte;
	}
	public String getGridDescripcion() {
		return gridDescripcion;
	}
	public void setGridDescripcion(String gridDescripcion) {
		this.gridDescripcion = gridDescripcion;
	}
	public String getGridReferencia() {
		return gridReferencia;
	}
	public void setGridReferencia(String gridReferencia) {
		this.gridReferencia = gridReferencia;
	}
	public String getGridTipoMov() {
		return gridTipoMov;
	}
	public void setGridTipoMov(String gridTipoMov) {
		this.gridTipoMov = gridTipoMov;
	}
	public String getGridMonto() {
		return gridMonto;
	}
	public void setGridMonto(String gridMonto) {
		this.gridMonto = gridMonto;
	}
	public String getGridCuentaClabe() {
		return gridCuentaClabe;
	}
	public void setGridCuentaClabe(String gridCuentaClabe) {
		this.gridCuentaClabe = gridCuentaClabe;
	}
	public String getGridRFC() {
		return gridRFC;
	}
	public void setGridRFC(String gridRFC) {
		this.gridRFC = gridRFC;
	}
	public String getGridEnviados() {
		return gridEnviados;
	}
	public void setGridEnviados(String gridEnviados) {
		this.gridEnviados = gridEnviados;
	}
	public String getIva() {
		return iva;
	}
	public void setIva(String iva) {
		this.iva = iva;
	}
	public String getFechaAplicar() {
		return fechaAplicar;
	}
	public void setFechaAplicar(String fechaAplicar) {
		this.fechaAplicar = fechaAplicar;
	}
	public String getNombreBeneficiario() {
		return nombreBeneficiario;
	}
	public void setNombreBeneficiario(String nombreBeneficiario) {
		this.nombreBeneficiario = nombreBeneficiario;
	}
	public String getClaveDispersion() {
		return claveDispersion;
	}
	public void setClaveDispersion(String claveDispersion) {
		this.claveDispersion = claveDispersion;
	}

	public String getClienteID() {
		return clienteID;
	}

	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}

	public String getFolioOperacion() {
		return folioOperacion;
	}

	public void setFolioOperacion(String folioOperacion) {
		this.folioOperacion = folioOperacion;
	}

	public String getGridTipoChequera() {
		return gridTipoChequera;
	}

	public void setGridTipoChequera(String gridTipoChequera) {
		this.gridTipoChequera = gridTipoChequera;
	}

	public String getGridConceptoDisp() {
		return gridConceptoDisp;
	}

	public void setGridConceptoDisp(String gridConceptoDisp) {
		this.gridConceptoDisp = gridConceptoDisp;
	}

	public String getCodigoLayaut() {
		return codigoLayaut;
	}

	public void setCodigoLayaut(String codigoLayaut) {
		this.codigoLayaut = codigoLayaut;
	}

	public String getConcepto() {
		return concepto;
	}

	public void setConcepto(String concepto) {
		this.concepto = concepto;
	}

	public String getCorreoBeneficiario() {
		return correoBeneficiario;
	}

	public void setCorreoBeneficiario(String correoBeneficiario) {
		this.correoBeneficiario = correoBeneficiario;
	}

	public String getBancoReceptor() {
		return bancoReceptor;
	}

	public void setBancoReceptor(String bancoReceptor) {
		this.bancoReceptor = bancoReceptor;
	}

	public String getPlazaBanxico() {
		return plazaBanxico;
	}

	public void setPlazaBanxico(String plazaBanxico) {
		this.plazaBanxico = plazaBanxico;
	}

	public String getFechaAplicacion() {
		return fechaAplicacion;
	}

	public void setFechaAplicacion(String fechaAplicacion) {
		this.fechaAplicacion = fechaAplicacion;
	}

	public String getClaveSucursales() {
		return claveSucursales;
	}

	public void setClaveSucursales(String claveSucursales) {
		this.claveSucursales = claveSucursales;
	}

	public String getClaveSucursal() {
		return claveSucursal;
	}

	public void setClaveSucursal(String claveSucursal) {
		this.claveSucursal = claveSucursal;
	}

	public String getTipoPago() {
		return tipoPago;
	}

	public void setTipoPago(String tipoPago) {
		this.tipoPago = tipoPago;
	}

	public String getGridTipoConcepto() {
		return gridTipoConcepto;
	}

	public void setGridTipoConcepto(String gridTipoConcepto) {
		this.gridTipoConcepto = gridTipoConcepto;
	}

	public String getNumeroOrden() {
		return numeroOrden;
	}

	public void setNumeroOrden(String numeroOrden) {
		this.numeroOrden = numeroOrden;
	}
	
}

