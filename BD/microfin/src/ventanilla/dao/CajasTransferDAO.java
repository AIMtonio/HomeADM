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

import javax.servlet.http.HttpServletRequest;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import contabilidad.dao.PolizaDAO;

import ventanilla.bean.CajasTransferBean;
import ventanilla.bean.IngresosOperacionesBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

public class CajasTransferDAO extends BaseDAO{

	public CajasTransferDAO(){
		super();
	}
	IngresosOperacionesDAO ingresosOperacionesDAO = null;
	PolizaDAO				polizaDAO				= new PolizaDAO();

	//Transaccion para la Transferencia entre cajas
	public MensajeTransaccionBean movCajasTransfer(final CajasTransferBean cajasTransferBean, final List listaDenominaciones, final String total){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		final IngresosOperacionesBean ingresosOperacionesBean = new IngresosOperacionesBean();
		ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.desTRANACaja+": "+Utileria.completaCerosIzquierda(cajasTransferBean.getCajaDestino(),3));
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
					for(int i=0; i<listaDenominaciones.size(); i++){
						ingresosOperacionesBean.setPolizaID(numeroPoliza);
						cajasTransferBean.setPolizaID(numeroPoliza);
						ingOpeBilletesMonBean = (IngresosOperacionesBean)listaDenominaciones.get(i);
						cajasTransferBean.setDenominacionID(ingOpeBilletesMonBean.getDenominacionID());
						cajasTransferBean.setCantidad(ingOpeBilletesMonBean.getCantidadDenominacion());

						ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnPolizaNo);
						ingresosOperacionesBean.setSucursalID(cajasTransferBean.getSucursalOrigen());
						ingresosOperacionesBean.setCajaID(cajasTransferBean.getCajaOrigen());
						ingresosOperacionesBean.setFecha(cajasTransferBean.getFecha());
						ingresosOperacionesBean.setMonedaID(cajasTransferBean.getMonedaID());
						ingresosOperacionesBean.setInstrumento(cajasTransferBean.getCajaOrigen()); //instrumento
						// cuando se da de alta la poliza en denominaciones requiere q la referencia lleve el concepto de poliza

						ingresosOperacionesBean.setReferenciaMov(cajasTransferBean.getReferencia()); //referencia mov
						ingresosOperacionesBean.setDesMovCaja(IngresosOperacionesBean.desTRANACaja+": "+Utileria.completaCerosIzquierda(cajasTransferBean.getCajaDestino(),3));


						mensajeBean = ingresosOperacionesDAO.altaDenominacionMovimientos(ingresosOperacionesBean, ingOpeBilletesMonBean, parametrosAuditoriaBean.getNumeroTransaccion(), false);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
						//si no produjo error se obtiene el numero de poliza
						mensajeBean = altaCajasTransfer(cajasTransferBean, parametrosAuditoriaBean.getNumeroTransaccion());
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}// For


					ingresosOperacionesBean.setMontoEnFirme(total);
					ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajEntTransCaj);
					mensajeBean = ingresosOperacionesDAO.altaMovsCaja(ingresosOperacionesBean,parametrosAuditoriaBean.getNumeroTransaccion(), false);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

					ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajTransCaj);
					mensajeBean = ingresosOperacionesDAO.altaMovsCaja(ingresosOperacionesBean,parametrosAuditoriaBean.getNumeroTransaccion(), false);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

					mensajeBean.setNombreControl("cajaDestino");
					mensajeBean.setConsecutivoString(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
					mensajeBean.setDescripcion("Transferencia Realizada Exitosamente.");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error de movimiento de transferencia en caja", e);
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

	//Transaccion para la Recepcion de Efectivo entre cajas
	public MensajeTransaccionBean movRecepcionTransfer(final CajasTransferBean cajasTransferBean, final List listaDenominaciones,
			final int tipoTransaccion,final HttpServletRequest request){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					IngresosOperacionesBean ingOpeBilletesMonBean = null;
					IngresosOperacionesBean ingresosOperacionesBean = new IngresosOperacionesBean();

					for(int i=0; i<listaDenominaciones.size(); i++){
						ingOpeBilletesMonBean = (IngresosOperacionesBean)listaDenominaciones.get(i);
						//actualizamos es estatus a R: Recepcion de Efectivo
						mensajeBean = actualizaCajasTransfer(cajasTransferBean, tipoTransaccion);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
						ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnPolizaNo);
						ingresosOperacionesBean.setSucursalID(cajasTransferBean.getSucursalOrigen());
						ingresosOperacionesBean.setCajaID(cajasTransferBean.getCajaOrigen());
						ingresosOperacionesBean.setFecha(cajasTransferBean.getFecha());
						ingresosOperacionesBean.setMonedaID(cajasTransferBean.getMonedaID());
						ingresosOperacionesBean.setInstrumento(cajasTransferBean.getCajaOrigen()); //instrumento
						// cuando se da de alta la poliza en denominaciones requiere q la referencia lleve el concepto de poliza
						ingresosOperacionesBean.setReferenciaMov(IngresosOperacionesBean.desRecepACaja+": "+request.getParameter("cajaOrigenVal"));
						ingresosOperacionesBean.setPolizaID(request.getParameter("polizaID"));
						ingresosOperacionesBean.setDesMovCaja(IngresosOperacionesBean.desRecepACaja+": "+request.getParameter("cajaOrigenVal"));

						mensajeBean = ingresosOperacionesDAO.altaDenominacionMovimientos(ingresosOperacionesBean, ingOpeBilletesMonBean, parametrosAuditoriaBean.getNumeroTransaccion(), false);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}

					}// FOR

					ingresosOperacionesBean.setMontoEnFirme(request.getParameter("sumTotalEnt"));
					ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajRecTransCaj);
					mensajeBean = ingresosOperacionesDAO.altaMovsCaja(ingresosOperacionesBean,parametrosAuditoriaBean.getNumeroTransaccion(), false);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

					ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalRecTransCaj);
					mensajeBean = ingresosOperacionesDAO.altaMovsCaja(ingresosOperacionesBean,parametrosAuditoriaBean.getNumeroTransaccion(), false);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					ingresosOperacionesBean.setCantidadMov(request.getParameter("sumTotalEnt"));
					ingresosOperacionesBean.setTotalEntrada(request.getParameter("sumTotalEnt"));
					ingresosOperacionesBean.setTotalSalida("0");
					ingresosOperacionesBean.setOpcionCajaID("0");
					ingresosOperacionesBean.setDenominaciones(cajasTransferBean.getDenominaciones());
					ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.desRecepACaja+": "+request.getParameter("cajaOrigenVal"));

					mensajeBean=ingresosOperacionesDAO.validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), false);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}


				}catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error de movimiento de transferencia en caja", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	//Alta para la Transferencia de Efectivo entre cajas
	public MensajeTransaccionBean altaCajasTransfer(final CajasTransferBean cajasTransferBean, final Long numTransaccion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CAJASTRANSFERALT(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,  ?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setLong("VarTransferID",numTransaccion);
								sentenciaStore.setInt("Par_SucOrigen",Utileria.convierteEntero(cajasTransferBean.getSucursalOrigen()));
								sentenciaStore.setInt("Par_SucDestino",Utileria.convierteEntero(cajasTransferBean.getSucursalDestino()));
								sentenciaStore.setDate("Par_Fecha",OperacionesFechas.conversionStrDate(cajasTransferBean.getFecha()));
								sentenciaStore.setInt("Par_DenominacionID",Utileria.convierteEntero(cajasTransferBean.getDenominacionID()));

								sentenciaStore.setString("Par_Cantidad",cajasTransferBean.getCantidad());
								sentenciaStore.setInt("Par_CajaOrigen",Utileria.convierteEntero(cajasTransferBean.getCajaOrigen()));
								sentenciaStore.setInt("Par_CajaDestino",Utileria.convierteEntero(cajasTransferBean.getCajaDestino()));
								sentenciaStore.setString("Par_Estatus",Constantes.STRING_VACIO);
								sentenciaStore.setInt("Par_MonedaID",Utileria.convierteEntero(cajasTransferBean.getMonedaID()));
								sentenciaStore.setLong("Par_PolizaID",Utileria.convierteLong(cajasTransferBean.getPolizaID()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de cajas de transferencia", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	//Actualización del estatus
	public MensajeTransaccionBean actualizaCajasTransfer(final CajasTransferBean cajasTransferBean, final int tipoTransaccion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CAJASTRANSFERACT(?,?, ?,?,?, ?,?,?, ?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setString("Par_FolioID",cajasTransferBean.getCajasTransferID());
								sentenciaStore.setLong("Par_NumAct",tipoTransaccion);

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualizar caja de transferencia", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	//Lista de Folios Recepcion Transfer
	public List listaFolios(int tipoLista, CajasTransferBean cajasTransferBean) {
		//Query con el Store Procedure
		String query = "call CAJASTRANSFERLIS(?,?,?,  ?,?,?, ?,?, ?,?);";
		Object[] parametros = {
				cajasTransferBean.getSucursalOrigen(),
				cajasTransferBean.getCajaDestino(),
				tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CajasTransferDAO.listaFolios",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CAJASTRANSFERLIS(" + Arrays.toString(parametros)  +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CajasTransferBean folios = new CajasTransferBean();
				folios.setCajasTransferID(resultSet.getString(1));
				folios.setDetalleFolios(resultSet.getString(1) + '-'+resultSet.getString(2)+ '-' +Utileria.completaCerosIzquierda(resultSet.getString(3), 3)+'-'+resultSet.getString(4));
				return folios;
			}
		});

		return matches;
	}
	//CONSULTA PARA ENTRADA DISPONIBLE POR DENOMINACION
	public List  consultaEntradaDenominacion(final CajasTransferBean cajasTransferBean, final int tipoConsulta){
		List listCajasTransferBean = null;
		try{

			//Query con el Store Procedure
			String query = "call CAJASTRANSFERCON(?,?, ?,?,?,?,?, ?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(cajasTransferBean.getCajasTransferID()),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"CajasTransferDAO.consultaEntradaDenominacion",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CAJASTRANFERCON(" + Arrays.toString(parametros)  +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CajasTransferBean cajasTransfer= new CajasTransferBean();
					cajasTransfer.setSucursalOrigen(resultSet.getString(1));
					cajasTransfer.setCajaOrigen(resultSet.getString(2));
					cajasTransfer.setDenominacionID(resultSet.getString(3));
					cajasTransfer.setCantidad(resultSet.getString(4));
					cajasTransfer.setPolizaID(resultSet.getString(5));
					return cajasTransfer;
				}
			});
			listCajasTransferBean= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de entrada de denominacion", e);
		}
		return listCajasTransferBean;
	}

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
