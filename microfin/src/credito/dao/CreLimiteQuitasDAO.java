package credito.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import tesoreria.bean.BloqueoBean;
import tesoreria.bean.DispersionBean;
import tesoreria.bean.DispersionGridBean;
import tesoreria.dao.OperDispersionDAO.Enum_Tipo_Naturaleza;



import credito.bean.CreLimiteQuitasBean;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class CreLimiteQuitasDAO extends BaseDAO{
	public CreLimiteQuitasDAO() {
		super();
	}

	final String salidaSi="S";

	//Consulta limite de quitas por producto de credito y clave de puesto
	public CreLimiteQuitasBean consultaLimQuitasProCrePuesto(CreLimiteQuitasBean creLimiteQuitasBean, int tipoConsulta) {
		CreLimiteQuitasBean creLimiteQuitas = new CreLimiteQuitasBean();
		try{
			//Query con el Store Procedure
			String query = "call CRELIMITEQUITASCON(?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(creLimiteQuitasBean.getProducCreditoID()),
					creLimiteQuitasBean.getClavePuestoID(),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					Constantes.STRING_VACIO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CRELIMITEQUITASCON(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CreLimiteQuitasBean creLimiteQuitasBeanConsulta = new CreLimiteQuitasBean();

					creLimiteQuitasBeanConsulta.setProducCreditoID(resultSet.getString("ProducCreditoID"));
					creLimiteQuitasBeanConsulta.setClavePuestoID(resultSet.getString("ClavePuestoID"));
					creLimiteQuitasBeanConsulta.setLimMontoCap(resultSet.getString("LimMontoCap"));
					creLimiteQuitasBeanConsulta.setLimPorcenCap(resultSet.getString("LimPorcenCap"));
					creLimiteQuitasBeanConsulta.setLimMontoIntere(resultSet.getString("LimMontoIntere"));

					creLimiteQuitasBeanConsulta.setLimPorcenIntere(resultSet.getString("LimPorcenIntere"));
					creLimiteQuitasBeanConsulta.setLimMontoMorato(resultSet.getString("LimMontoMorato"));
					creLimiteQuitasBeanConsulta.setLimPorcenMorato(resultSet.getString("LimPorcenMorato"));
					creLimiteQuitasBeanConsulta.setLimMontoAccesorios(resultSet.getString("LimMontoAccesorios"));
					creLimiteQuitasBeanConsulta.setLimPorcenAccesorios(resultSet.getString("LimPorcenAccesorios"));

					creLimiteQuitasBeanConsulta.setNumMaxCondona(resultSet.getString("NumMaxCondona"));
					creLimiteQuitasBeanConsulta.setLimMontoNotasCargos(resultSet.getString("LimMontoNotasCargos"));
					creLimiteQuitasBeanConsulta.setLimPorcenNotasCargos(resultSet.getString("LimPorcenNotasCargos"));
					return creLimiteQuitasBeanConsulta;
				}
			});
			creLimiteQuitas = matches.size() > 0 ? (CreLimiteQuitasBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de limites de quitas por producto de credito", e);

		}
		return creLimiteQuitas;
	}

	//grama Limite Quitas
	public MensajeTransaccionBean altaLimiteQuitas(final CreLimiteQuitasBean creLimiteQuitasBean){
		MensajeTransaccionBean mensajeResultado = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensajeResultado = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {


				ArrayList listaDetalleGrid = null ;
				String [] arregloProductos = null;
				CreLimiteQuitasBean creLimQuitasDeListaBean = null;
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					listaDetalleGrid = (ArrayList) detalleGrid(creLimiteQuitasBean);
					if(creLimiteQuitasBean.getProductosAplica()!=null){
						arregloProductos = creLimiteQuitasBean.getProductosAplica().split("\\,");
					}
					String prodCreIDPrincipal= creLimiteQuitasBean.getProducCreditoID();
					mensajeBean = bajaMovimientosLimQuitas(prodCreIDPrincipal);
					if( mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion()+" <br> No. Producto Crédito: "+prodCreIDPrincipal);
					}
					if(!listaDetalleGrid.isEmpty()) {
						for(int i=0; i < listaDetalleGrid.size(); i++){
							creLimQuitasDeListaBean = (CreLimiteQuitasBean) listaDetalleGrid.get(i);
							mensajeBean = altaMovimientosLimQuitas(creLimQuitasDeListaBean, parametrosAuditoriaBean.getNumeroTransaccion(),
									prodCreIDPrincipal);
							if( mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion()+" <br> No. Producto Crédito: "+prodCreIDPrincipal);
							}

						}
					}


					if(arregloProductos!=null){

						for(int i=0; i < arregloProductos.length; i++){

							if( arregloProductos[i]!=""){
								if(Integer.parseInt(arregloProductos[i])>=100 ){

									mensajeBean = bajaMovimientosLimQuitas(arregloProductos[i]);
									if( mensajeBean.getNumero()!=0){
										throw new Exception(mensajeBean.getDescripcion()+" <br> No. Producto Crédito: "+arregloProductos[i]);
									}

									for(int j=0; j < listaDetalleGrid.size(); j++){
										creLimQuitasDeListaBean = (CreLimiteQuitasBean) listaDetalleGrid.get(j);
										mensajeBean = altaMovimientosLimQuitas(creLimQuitasDeListaBean, parametrosAuditoriaBean.getNumeroTransaccion(),
												arregloProductos[i]);
										if( mensajeBean.getNumero()!=0){
											throw new Exception(mensajeBean.getDescripcion()+" <br> No. Producto Crédito: "+arregloProductos[i]);
										}

									}
								}
							}

						}

					}



				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en gramas de limites de quitas", e);
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensajeResultado;
	}


	// Insert a la tabla CRELIMITEQUITAS

	public MensajeTransaccionBean altaMovimientosLimQuitas(final CreLimiteQuitasBean creLimiteQuitasBean, final long numeroTransaccion,
			final String producCreditoID){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CRELIMITEQUITASALT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_ProducCreditoID", Utileria.convierteEntero(producCreditoID));
									sentenciaStore.setString("Par_ClavePuestoID", creLimiteQuitasBean.getClavePuestoID());
									sentenciaStore.setDouble("Par_LimMontoCap",Utileria.convierteDoble(creLimiteQuitasBean.getLimMontoCap()));
									sentenciaStore.setDouble("Par_LimPorcenCap",Utileria.convierteDoble(creLimiteQuitasBean.getLimPorcenCap()));
									sentenciaStore.setDouble("Par_LimMontoIntere",Utileria.convierteDoble(creLimiteQuitasBean.getLimMontoIntere()));
									sentenciaStore.setDouble("Par_LimPorcenIntere",Utileria.convierteDoble(creLimiteQuitasBean.getLimPorcenIntere()));
									sentenciaStore.setDouble("Par_LimMontoMorato",Utileria.convierteDoble(creLimiteQuitasBean.getLimMontoMorato()));
									sentenciaStore.setDouble("Par_LimPorcenMorato",Utileria.convierteDoble(creLimiteQuitasBean.getLimPorcenMorato()));
									sentenciaStore.setDouble("Par_LimMontoAccesorios",Utileria.convierteDoble(creLimiteQuitasBean.getLimMontoAccesorios()));
									sentenciaStore.setDouble("Par_LimPorcenAccesorios",Utileria.convierteDoble(creLimiteQuitasBean.getLimPorcenAccesorios() ));

									sentenciaStore.setDouble("Par_LimMontoNotasCargos",Utileria.convierteDoble(creLimiteQuitasBean.getLimMontoNotasCargos()));
									sentenciaStore.setDouble("Par_LimPorcenNotasCargos",Utileria.convierteDoble(creLimiteQuitasBean.getLimPorcenNotasCargos() ));

									sentenciaStore.setDouble("Par_NumMaxCondona",Utileria.convierteEntero(creLimiteQuitasBean.getNumMaxCondona()));


									sentenciaStore.setString("Par_Salida",salidaSi);

									//Parametros de OutPut
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",numeroTransaccion);

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
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
										mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));


									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CreLimiteQutasDao.altaMovimientosLimQuitas(Err 1.1)");
									}
									return mensajeTransaccion;
								}
							});

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .CreLimiteQutasDao.altaMovimientosLimQuitas(Err 1.2)");

					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al insertar la table de credito limite de quitas", e);

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	// Baja completa de limite de quitas por producto de credito antes de grabar nuevas
	public MensajeTransaccionBean bajaMovimientosLimQuitas(final String producCreditoID){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CRELIMITEQUITASBAJ(?,?,?,?,?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_ProducCreditoID", Utileria.convierteEntero(producCreditoID));
									sentenciaStore.setString("Par_Salida",salidaSi);

									//Parametros de OutPut
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
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
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
										mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));


									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CreLimiteQutasDao.bajaMovimientosLimQuitas(Err 1.1)");
									}
									return mensajeTransaccion;
								}
							});

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .CreLimiteQutasDao.bajaMovimientosLimQuitas(Err 1.2)");

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de limite de quitas por producto de credito", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/* recorrer el gird */
	public List detalleGrid(CreLimiteQuitasBean creLimiteQuitasBean ){


		List<String>  clavePuestoIDL = creLimiteQuitasBean.getClavePuestoIDLis();
		List<String>  limMontoCapL= creLimiteQuitasBean.getLimMontoCapLis();
		List<String>  limPorcenCapL= creLimiteQuitasBean.getLimPorcenCapLis();
		List<String>  limMontoIntereL= creLimiteQuitasBean.getLimMontoIntereLis();
		List<String>  limPorcenIntereL= creLimiteQuitasBean.getLimPorcenIntereLis();
		List<String>  limMontoMoratoL= creLimiteQuitasBean.getLimMontoMoratoLis();
		List<String>  limPorcenMoratoL= creLimiteQuitasBean.getLimPorcenMoratoLis();
		List<String>  limMontoAccesoriosL= creLimiteQuitasBean.getLimMontoAccesoriosLis();
		List<String>  limPorcenAccesoriosL= creLimiteQuitasBean.getLimPorcenAccesoriosLis();
		List<String>  numMaxCondonaL= creLimiteQuitasBean.getNumMaxCondonaLis();

		List<String>  limMontoNotasCargosL= creLimiteQuitasBean.getLimMontoNotasCargosLis();
		List<String>  limPorcenNotasCargosL= creLimiteQuitasBean.getLimPorcenNotasCargosLis();

		ArrayList listaDetalle = new ArrayList();
		CreLimiteQuitasBean quitasBeanSalida  = null;

		int tamanio = 0;
		if(numMaxCondonaL!=null){
			tamanio=numMaxCondonaL.size();
		}
		for(int i=0; i<tamanio; i++){
			quitasBeanSalida = new CreLimiteQuitasBean();
			quitasBeanSalida.setProducCreditoID(creLimiteQuitasBean.getProducCreditoID());
			quitasBeanSalida.setClavePuestoID(clavePuestoIDL.get(i));
			quitasBeanSalida.setLimMontoCap(limMontoCapL.get(i));
			quitasBeanSalida.setLimPorcenCap(limPorcenCapL.get(i));
			quitasBeanSalida.setLimMontoIntere(limMontoIntereL.get(i));
			quitasBeanSalida.setLimPorcenIntere(limPorcenIntereL.get(i));
			quitasBeanSalida.setLimMontoMorato(limMontoMoratoL.get(i));
			quitasBeanSalida.setLimPorcenMorato(limPorcenMoratoL.get(i));
			quitasBeanSalida.setLimMontoAccesorios(limMontoAccesoriosL.get(i));
			quitasBeanSalida.setLimPorcenAccesorios(limPorcenAccesoriosL.get(i));
			quitasBeanSalida.setLimMontoNotasCargos(limMontoNotasCargosL.get(i));
			quitasBeanSalida.setLimPorcenNotasCargos(limPorcenNotasCargosL.get(i));
			quitasBeanSalida.setNumMaxCondona(numMaxCondonaL.get(i));

			listaDetalle.add( quitasBeanSalida);
		}

		return listaDetalle;
	}

	public List consultaGridDetallesPuestos(CreLimiteQuitasBean creLimiteQuitasBean, int tipoConsulta) {
		List detallesPuestos = null;;
		try{
			//Query con el Store Procedure
			String query = "call CRELIMITEQUITASCON(?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(creLimiteQuitasBean.getProducCreditoID()),
					Constantes.ENTERO_CERO,
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					Constantes.STRING_VACIO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CRELIMITEQUITASCON(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CreLimiteQuitasBean creLimiteQuitasBeanConsulta = new CreLimiteQuitasBean();

					creLimiteQuitasBeanConsulta.setProducCreditoID(resultSet.getString("ProducCreditoID"));
					creLimiteQuitasBeanConsulta.setClavePuestoID(resultSet.getString("ClavePuestoID"));
					creLimiteQuitasBeanConsulta.setLimMontoCap(resultSet.getString("LimMontoCap"));
					creLimiteQuitasBeanConsulta.setLimPorcenCap(resultSet.getString("LimPorcenCap"));
					creLimiteQuitasBeanConsulta.setLimMontoIntere(resultSet.getString("LimMontoIntere"));

					creLimiteQuitasBeanConsulta.setLimPorcenIntere(resultSet.getString("LimPorcenIntere"));
					creLimiteQuitasBeanConsulta.setLimMontoMorato(resultSet.getString("LimMontoMorato"));
					creLimiteQuitasBeanConsulta.setLimPorcenMorato(resultSet.getString("LimPorcenMorato"));
					creLimiteQuitasBeanConsulta.setLimMontoAccesorios(resultSet.getString("LimMontoAccesorios"));
					creLimiteQuitasBeanConsulta.setLimPorcenAccesorios(resultSet.getString("LimPorcenAccesorios"));

					creLimiteQuitasBeanConsulta.setNumMaxCondona(resultSet.getString("NumMaxCondona"));
					creLimiteQuitasBeanConsulta.setNumTransaccion(resultSet.getString("NumTransaccion"));
					creLimiteQuitasBeanConsulta.setLimMontoNotasCargos(resultSet.getString("LimMontoNotasCargos"));
					creLimiteQuitasBeanConsulta.setLimPorcenNotasCargos(resultSet.getString("LimPorcenNotasCargos"));

					return creLimiteQuitasBeanConsulta;
				}
			});
			detallesPuestos = matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de limites de quitas", e);

		}
		return detallesPuestos;
	}

	// consulta de productos de credito en los que aplica
	public List conProdsCreAplica(CreLimiteQuitasBean creLimiteQuitasBean, int tipoConsulta) {
		List detallesPuestos = null;;
		try{
			//Query con el Store Procedure
			String query = "call CRELIMITEQUITASCON(?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(creLimiteQuitasBean.getProducCreditoID()),
					Constantes.ENTERO_CERO,
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					Constantes.STRING_VACIO,
					Constantes.ENTERO_CERO,
					Utileria.convierteEntero(creLimiteQuitasBean.getNumTransaccion()),

			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CRELIMITEQUITASCON(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CreLimiteQuitasBean creLimiteQuitasBeanConsulta = new CreLimiteQuitasBean();

					creLimiteQuitasBeanConsulta.setProducCreditoID(resultSet.getString("ProducCreditoID"));

					return creLimiteQuitasBeanConsulta;
				}
			});
			detallesPuestos = matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de productos de credito en los que aplica limite de quitas", e);
		}
		return detallesPuestos;
	}

}// llave fin de la clase



