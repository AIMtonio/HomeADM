package general.bean;

import java.sql.Date;

public interface ParametrosAuditoriaInterfaz {

	Date getFechaAplicacion();	
	void setFechaAplicacion(Date fechaAplicacion);	
	int getNumeroSucursalMatriz();	
	void setNumeroSucursalMatriz(int numeroSucursalMatriz);	
	String getNombreSucursalMatriz();
	void setNombreSucursalMatriz(String nombreSucursalMatriz);
	String getTelefonoLocal();
	void setTelefonoLocal(String telefonoLocal);	
	String getTelefonoInterior();	
	void setTelefonoInterior(String telefonoInterior);	
	int getNumeroInstitucion();
	void setNumeroInstitucion(int numeroInstitucion);
	String getNombreInstitucion();
	void setNombreInstitucion(String nombreInstitucion);	
	String getRepresentanteLegal();
	void setRepresentanteLegal(String representanteLegal);
	String getRfcRepresentante();
	void setRfcRepresentante(String rfcRepresentante);
	int getNumeroMonedaBase();
	void setNumeroMonedaBase(int numeroMonedaBase);
	String getNombreMonedaBase();
	void setNombreMonedaBase(String nombreMonedaBase);
	String getDesCortaMonedaBase();
	void setDesCortaMonedaBase(String desCortaMonedaBase);
	String getSimboloMonedaBase();
	void setSimboloMonedaBase(String simboloMonedaBase);
	int getNumeroUsuario();
	void setNumeroUsuario(int numeroUsuario);
	String getClaveUsuario();
	void setClaveUsuario(String claveUsuario);
	int getPerfilUsuario();
	void setPerfilUsuario(int perfilUsuario);
	String getNombreUsuario();
	void setNombreUsuario(String nombreUsuario);
	String getCorreoUsuario();
	void setCorreoUsuario(String correoUsuario);
	int getSucursal();
	void setSucursal(int sucursal);
	Date getFechaSucursal();
	void setFechaSucursal(Date fechaSucursal);
	String getNombreSucursal();
	void setNombreSucursal(String nombreSucursal);
	String getGerenteSucursal();
	void setGerenteSucursal(String gerenteSucursal);
	String getNumeroCaja();
	void setNumeroCaja(String numeroCaja);
	int getLoginsFallidos();
	void setLoginsFallidos(int loginsFallidos);
	String getMensajeLogin();
	void setMensajeLogin(String mensajeLogin);
	float getTasaISR();
	void setTasaISR(float tasaISR);
	int getEmpresaID();
	void setEmpresaID(int empresaID);
	String getRutaArchivos();
	void setRutaArchivos(String rutaArchivos);
	
	String getCajaID();
	void setCajaID(String cajaID);
	String getTipoCaja();
	void setTipoCaja(String tipoCaja);
	String getEstatusCaja();
	void setEstatusCaja(String estatusCaja);
	
	String getSaldoEfecMN();
	void setSaldoEfecMN(String saldoEfecMN);
	String getSaldoEfecME();
	void setSaldoEfecME(String saldoEfecME);
	String getLimiteEfectivoMN();
	void setLimiteEfectivoMN(String limiteEfectivoMN);
	String getTipoCajaDes();
	void setTipoCajaDes(String tipoCajaDes);	

	String getClavePuestoID();
	void setClavePuestoID(String clavePuestoID);	
	
	String getRutaArchivosPLD();
	void setRutaArchivosPLD(String rutaArchivosPLD);	
	
	float getIvaSucursal();
	void setIvaSucursal(float ivaSucursal);	
	
	String getEdoMunSucursal();
	void setEdoMunSucursal(String edoMunSucursal);
	
	String getImpTicket();
	void setImpTicket(String impTicket);
	
	String getTipoImpTicket();
	void setTipoImpTicket(String tipoImpTicket);
	
	double getMontoAportacion();
	void setMontoAportacion(double montoAportacion);
	
	double getMontoPolizaSegA();
	void setMontoPolizaSegA(double montoPolizaSegA);
	
	double getMontoSegAyuda();
	void setMontoSegAyuda(double MontoSegAyuda);
	
	double getSalMinDF();
	void setSalMinDF(double salMinDF);
	
	String  getDirFiscal();
	void setDirFiscal(String dirFiscal);
	
	String  getRfcInst();
	void setRfcInst (String rfcInst);
	
	String  getNombreJefeCobranza();
	void setNombreJefeCobranza (String nombreJefeCobranza);
	
	String  getNomJefeOperayPromo();
	void setNomJefeOperayPromo (String nomJefeOperayPromo);
	
	String  getImpSaldoCred();
	void setImpSaldoCred (String impSaldoCred);
	
	
	String  getImpSaldoCta();
	void setImpSaldoCta (String impSaldoCta);
	
	String getNombreCortoInst();
	void setNombreCortoInst (String nombreCortoInst);
	
	String getGerenteGeneral();
	void setGerenteGeneral(String gerenteGeneral);
	
	String getPresidenteConsejo();
	void setPresidenteConsejo(String presidenteConsejo);
	
	String getJefeContabilidad();
	void setJefeContabilidad(String jefeContabilidad);
	
	String getRecursoTicketVent();
	void setRecursoTicketVent(String recursoTicketVent);
	
	String getRolTesoreria();//--
	void setRolTesoreria(String rolTesoreria);//--
	
	String getRolAdminTeso();//--
	void setRolAdminTeso(String rolAdminTeso);//--
	
	String getMostrarSaldDisCtaYSbc();
	void setMostrarSaldDisCtaYSbc(String mostrarSaldDisCtaYSbc);	
	
	String getFuncionHuella();
	void setFuncionHuella(String funcionHuella);

	String getOrigenDatos();
	void setOrigenDatos(String OrigenDatos);
	
	String getMostrarPrefijo();
	void setMostrarPrefijo(String MostrarPrefijo);

	String getCambiaPromotor();
	void setCambiaPromotor(String cambiaPromotor);

}
