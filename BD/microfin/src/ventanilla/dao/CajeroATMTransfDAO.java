package ventanilla.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import contabilidad.dao.PolizaDAO;

import ventanilla.bean.CajeroATMTransfBean;
import ventanilla.bean.IngresosOperacionesBean;


import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

public class CajeroATMTransfDAO extends BaseDAO{

	public CajeroATMTransfDAO (){
		super();
	}

	IngresosOperacionesDAO ingresosOperacionesDAO = null;
	PolizaDAO				polizaDAO				= new PolizaDAO();

	public MensajeTransaccionBean envioTransferCajeroATM(final CajeroATMTransfBean cajeroATMTransfBean, final List listaDenominaciones){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		final IngresosOperacionesBean ingresosOperacionesBean = new IngresosOperacionesBean();
		ingresosOperacionesBean.setDescripcionMov(CajeroATMTransfBean.desTransACajeroATM+" : "+cajeroATMTransfBean.getCajeroDestinoID());
		ingresosOperacionesBean.setConceptoCon(ingresosOperacionesBean.concepContaDepVent);
		int	contador  = 0;
		while(contador <=3){
			contador ++;
			polizaDAO.generaPolizaID(ingresosOperacionesBean,parametrosAuditoriaBean.getNumeroTransaccion());
			if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0){
				break;
			}
		}
		if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) >0){
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					String numeroPoliza = ingresosOperacionesBean.getPolizaID();
					IngresosOperacionesBean ingOpeBilletesMonBean = null;
					IngresosOperacionesBean ingresosOperacionesBean = new IngresosOperacionesBean();


					ingresosOperacionesBean.setSucursalID(cajeroATMTransfBean.getSucursalID());
					ingresosOperacionesBean.setCajaID(cajeroATMTransfBean.getCajeroOrigenID());
					ingresosOperacionesBean.setFecha(cajeroATMTransfBean.getFecha());
					ingresosOperacionesBean.setMonedaID(cajeroATMTransfBean.getMonedaID());
					ingresosOperacionesBean.setInstrumento(cajeroATMTransfBean.getCajeroOrigenID()); //instrumento
					ingresosOperacionesBean.setReferenciaMov(cajeroATMTransfBean.getReferencia()); //referencia mov
					ingresosOperacionesBean.setDesMovCaja(CajeroATMTransfBean.desTransACajeroATM+" : "+cajeroATMTransfBean.getCajeroDestinoID());

					//Moviemiento de entrada en Caja
					ingresosOperacionesBean.setMontoEnFirme(cajeroATMTransfBean.getCantidad());
					ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeEntradaTransferATM);
					mensajeBean = ingresosOperacionesDAO.altaMovsCaja(ingresosOperacionesBean,parametrosAuditoriaBean.getNumeroTransaccion(), false);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					// Moviemiento de Salida en Caja
					ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeSalidaTransferATM);
					mensajeBean = ingresosOperacionesDAO.altaMovsCaja(ingresosOperacionesBean,parametrosAuditoriaBean.getNumeroTransaccion(), false);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

					for(int i=0; i<listaDenominaciones.size(); i++){
						ingOpeBilletesMonBean = (IngresosOperacionesBean)listaDenominaciones.get(i);
						ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnPolizaNo);
						ingresosOperacionesBean.setPolizaID(numeroPoliza);

						mensajeBean = ingresosOperacionesDAO.altaDenominacionMovimientos(ingresosOperacionesBean, ingOpeBilletesMonBean, parametrosAuditoriaBean.getNumeroTransaccion(), false);

						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}


					//se da de alta la trasferencia y un detalle de la poliza
					cajeroATMTransfBean.setPolizaID(numeroPoliza);
					mensajeBean = altaTransferenciaATM(cajeroATMTransfBean, parametrosAuditoriaBean.getNumeroTransaccion());
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					ingresosOperacionesBean.setCantidadMov(cajeroATMTransfBean.getCantidad());
					ingresosOperacionesBean.setTotalSalida(cajeroATMTransfBean.getCantidad());
					ingresosOperacionesBean.setTotalEntrada("0");
					ingresosOperacionesBean.setOpcionCajaID("0");
					ingresosOperacionesBean.setDenominaciones(cajeroATMTransfBean.getDenominaciones());
					ingresosOperacionesBean.setDescripcionMov(CajeroATMTransfBean.desTransACajeroATM+" : "+cajeroATMTransfBean.getCajeroDestinoID());

					mensajeBean=ingresosOperacionesDAO.validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), false);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

					mensajeBean.setNombreControl("folioTransaccion");
					mensajeBean.setConsecutivoString(numeroPoliza+","+parametrosAuditoriaBean.getNumeroTransaccion());

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la transferencia a Cajero ATM", e);
				}
				return mensajeBean;
			}
		});
		}else{
			mensaje.setNumero(999);
			mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");

		}
		return mensaje;
	}


	public MensajeTransaccionBean altaTransferenciaATM(final CajeroATMTransfBean cajeroATMTransfBean, final long numTransaccion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CAJEROATMTRANSFPRO(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setString("Par_CajeroOrigenID",cajeroATMTransfBean.getCajeroOrigenID());
								sentenciaStore.setString("Par_CajeroDestinoID",cajeroATMTransfBean.getCajeroDestinoID());
								sentenciaStore.setDouble("Par_Cantidad",Utileria.convierteDoble(cajeroATMTransfBean.getCantidad()));
								sentenciaStore.setInt("Par_MonedaID",Utileria.convierteEntero(cajeroATMTransfBean.getMonedaID()));
								sentenciaStore.setInt("Par_SucursalID",Utileria.convierteEntero(cajeroATMTransfBean.getSucursalID()));
								sentenciaStore.setInt("Par_Poliza",Utileria.convierteEntero(cajeroATMTransfBean.getPolizaID()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",numTransaccion);

								 loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());

								return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																											DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");

								}
								return mensajeTransaccion;
							}
						}
						);
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en el alta de la Transferencia", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean recepcionTransferCajeroATM(final CajeroATMTransfBean cajeroATMTransfBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call ATMRECEPTRANSFPRO(?,?,?,?,?, ?,?,?,?,?, ?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_CajeroTransfID",Utileria.convierteEntero(cajeroATMTransfBean.getCajeroTransferID()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

								 loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());

								return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																											DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									mensajeTransaccion.setConsecutivoString((resultadosStore.getString(4)));
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
								return mensajeTransaccion;
							}
						}
						);
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la Recepcion de Transferencia Cajero ATM", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	// consulta  principal de Cajeros ATM
	public CajeroATMTransfBean consultaPorDestino(CajeroATMTransfBean cajeroATMTransfBean, int tipoConsulta) {
		CajeroATMTransfBean cajeroATMTransf = null;

		try{
			String query = "call CAJEROATMTRANSFCON(?,?,?,?,?, ?,?,?,?,?, ?);";
			Object[] parametros = {
									Utileria.convierteEntero(cajeroATMTransfBean.getCajeroTransferID()),
									cajeroATMTransfBean.getCajeroOrigenID(),
									cajeroATMTransfBean.getCajeroDestinoID(),
									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									OperacionesFechas.FEC_VACIA,
									Constantes.STRING_VACIO,
									"consultaPrincipal",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};



			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CAJEROATMTRANSFCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					CajeroATMTransfBean cajeroATMTransf = new CajeroATMTransfBean();

					cajeroATMTransf.setCajeroTransferID(resultSet.getString("CajeroTransfID"));
					cajeroATMTransf.setCajeroOrigenID(resultSet.getString("CajeroOrigenID"));
					cajeroATMTransf.setCajeroDestinoID(resultSet.getString("CajeroDestinoID"));
					cajeroATMTransf.setFecha(resultSet.getString("Fecha"));
					cajeroATMTransf.setCantidad(resultSet.getString("Cantidad"));
					cajeroATMTransf.setEstatus(resultSet.getString("Estatus"));
					cajeroATMTransf.setMonedaID(resultSet.getString("MonedaID"));
					cajeroATMTransf.setSucursalID(resultSet.getString("SucursalOrigen"));

					return cajeroATMTransf;
				}
			});
			cajeroATMTransf= matches.size() > 0 ? (CajeroATMTransfBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta Principal de Cajeros ATM", e);
		}
		return cajeroATMTransf;
	}
	//Lista de Transferencias
	public List listaForanea(int tipoLista, CajeroATMTransfBean cajeroATMTransfBean) {
		//Query con el Store Procedure
		String query = "call CAJEROATMTRANSFLIS(?,?,?,?,?,  ?,?,?,?,?, ?);";
		Object[] parametros = {
				Utileria.convierteEntero(cajeroATMTransfBean.getCajeroTransferID()),
				cajeroATMTransfBean.getCajeroDestinoID(),
				Utileria.convierteEntero(cajeroATMTransfBean.getUsuarioID()),

				tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CajeroATMTransfDAO.listaForanea",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CAJEROATMTRANSFLIS(" + Arrays.toString(parametros)  +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CajeroATMTransfBean cajeroATMTransf = new CajeroATMTransfBean();
				cajeroATMTransf.setCajeroTransferID(resultSet.getString(1));
				cajeroATMTransf.setDescripcionTransfer((resultSet.getString(2)));
				return cajeroATMTransf;
			}
		});

		return matches;
	}

	//---------getter y setter---------------------

	public IngresosOperacionesDAO getIngresosOperacionesDAO() {
		return ingresosOperacionesDAO;
	}

	public void setIngresosOperacionesDAO(
			IngresosOperacionesDAO ingresosOperacionesDAO) {
		this.ingresosOperacionesDAO = ingresosOperacionesDAO;
	}


	public PolizaDAO getPolizaDAO() {
		return polizaDAO;
	}


	public void setPolizaDAO(PolizaDAO polizaDAO) {
		this.polizaDAO = polizaDAO;
	}

}
