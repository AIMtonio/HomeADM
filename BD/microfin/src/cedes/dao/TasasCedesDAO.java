package cedes.dao;

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
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;
import cedes.bean.TasasCedesBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class TasasCedesDAO extends BaseDAO {



	private final static String salidaPantalla = "S";

	/* metodo que manda llamar los metodo para dar de alta tasa de Cedes*/
	public MensajeTransaccionBean procesarAlta(final TasasCedesBean bean, final List listaSucursales) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					TasasCedesBean beanV;
					TasasCedesBean beanD;
					if(listaSucursales!=null){
						if(listaSucursales.size()>0){
							bean.setBandera("S");
						}else{
							bean.setBandera("N");
						}

						for(int i=0; i<listaSucursales.size(); i++){
							/* obtenemos un bean de la lista */
							beanV = (TasasCedesBean)listaSucursales.get(i);
							bean.setTasaID("0");
							bean.setTipoProdID(Integer.toString(bean.getTipoCedeID()));
							bean.setTipoInstrumentoID("28");
							mensajeBean = validaciones(bean,beanV,parametrosAuditoriaBean.getNumeroTransaccion());
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
					}

						mensajeBean = altaTasas(bean,parametrosAuditoriaBean.getNumeroTransaccion());
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
						bean.setTasaCedeID(mensajeBean.getConsecutivoString());
						String TasaID=bean.getTasaCedeID();
						if(listaSucursales!=null){
							for(int i=0; i<listaSucursales.size(); i++){
								/* obtenemos un bean de la lista */
								beanD = (TasasCedesBean)listaSucursales.get(i);
								mensajeBean = altaSucursales(bean,beanD,parametrosAuditoriaBean.getNumeroTransaccion());
								if(mensajeBean.getNumero()!=0){
									throw new Exception(mensajeBean.getDescripcion());
								}
							}
						}

						mensajeBean.setConsecutivoString(TasaID);
						mensajeBean.setDescripcion("Tasa de CEDES Agregada Exitosamente: "+mensajeBean.getConsecutivoString());

				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al Procesar Alta de Tasas de CEDES.", e);
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;

	}// fin de procesar alta


	/* metodo que manda llamar los metodos para la modificacion de Tasas por Cedes*/
	public MensajeTransaccionBean procesarModificacion(final TasasCedesBean bean, final List listaSucursales , final String tasa) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					TasasCedesBean beanV;
					TasasCedesBean beanD;
					if(listaSucursales!=null){
						if(listaSucursales.size()>0){
							bean.setBandera("S");
						}else{
							bean.setBandera("N");
						}

						for(int i=0; i<listaSucursales.size(); i++){
							/* obtenemos un bean de la lista */
							beanV = (TasasCedesBean)listaSucursales.get(i);
							bean.setTasaID(tasa);
							bean.setTipoProdID(Integer.toString(bean.getTipoCedeID()));
							bean.setTipoInstrumentoID("28");
							mensajeBean = validaciones(bean,beanV,parametrosAuditoriaBean.getNumeroTransaccion());
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
					}

						mensajeBean = modificaTasas(bean,parametrosAuditoriaBean.getNumeroTransaccion());
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
						bean.setTasaCedeID(mensajeBean.getConsecutivoString());
						String TasaID=bean.getTasaCedeID();
						if(listaSucursales!=null){
							for(int i=0; i<listaSucursales.size(); i++){
								/* obtenemos un bean de la lista */
								beanD = (TasasCedesBean)listaSucursales.get(i);
								if(beanD.getEstatus().equalsIgnoreCase("A")){
									mensajeBean = altaSucursales(bean,beanD,parametrosAuditoriaBean.getNumeroTransaccion());
									if(mensajeBean.getNumero()!=0){
										throw new Exception(mensajeBean.getDescripcion());
									}
								}

							}
						}
						mensajeBean.setConsecutivoString(TasaID);
						mensajeBean.setDescripcion("Tasa de CEDES Modificada Exitosamente: "+tasa);
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al Procesar Modificacion de Tasas de CEDES.", e);
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;

	}// fin de procesar modifica

	/*Metodo para dar de alta tasa de CEDES*/
	public MensajeTransaccionBean altaTasas(final TasasCedesBean bean, final long Numtransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
	//	transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call TASASCEDESALT(?,?,?,?,?,  	?,?,?,?,?, " +
										  						   "?,?,?,  	?,?,?," +
										  						   "?,?,?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_TipoCedeID",bean.getTipoCedeID());
								sentenciaStore.setDouble("Par_MontoInferior",Utileria.convierteDoble(bean.getMontoInferior()));
								sentenciaStore.setDouble("Par_MontoSuperior",Utileria.convierteDoble(bean.getMontoSuperior()));
								sentenciaStore.setInt("Par_PlazoInferior",bean.getPlazoInferior());
								sentenciaStore.setInt("Par_PlazoSuperior",bean.getPlazoSuperior());

								sentenciaStore.setString("Par_Calificacion",bean.getCalificacion());
								sentenciaStore.setDouble("Par_TasaFija",Utileria.convierteDoble(bean.getTasaFija()));
								sentenciaStore.setInt("Par_TasaBase",Utileria.convierteEntero(bean.getTasaBase()));
								sentenciaStore.setDouble("Par_SobreTasa",Utileria.convierteDoble(bean.getSobreTasa()));
								sentenciaStore.setDouble("Par_PisoTasa",Utileria.convierteDoble(bean.getPisoTasa()));

								sentenciaStore.setDouble("Par_TechoTasa",Utileria.convierteDoble(bean.getTechoTasa()));
								sentenciaStore.setInt("Par_CalculoInteres",Utileria.convierteEntero(bean.getCalculoInteres()));
								sentenciaStore.setString("Par_Validacion",bean.getBandera());

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",Numtransaccion);

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
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Tasas de CEDES", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	/* da de alta una sucursal referente a la tasa*/
	public MensajeTransaccionBean altaSucursales(final TasasCedesBean bean, final  TasasCedesBean beanD, final long Numtransaccion) {
	MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
				String query = "call TASACEDESUCURSALESALT(?,?,?,?,?, ?,?,?,  ?,?,?,?,?,?,?);";

				CallableStatement sentenciaStore = arg0.prepareCall(query);

					sentenciaStore.setInt("Par_TasaCedeID", Utileria.convierteEntero(bean.getTasaCedeID()));
					sentenciaStore.setInt("Par_TipoCedeID", beanD.getTipoCedeID());
					sentenciaStore.setInt("Par_SucursalID",Utileria.convierteEntero(beanD.getSucursalID()));
					sentenciaStore.setInt("Par_EstadoID", Utileria.convierteEntero(beanD.getEstadoID()));
					sentenciaStore.setString("Par_Estatus",beanD.getEstatus());

					sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
					sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
					sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

					sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
					sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());
					sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
					sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
					sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
					sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
					sentenciaStore.setLong("Aud_NumTransaccion",Numtransaccion);
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TASACEDESUCURSALESALT(" + sentenciaStore.toString() + ")");
					return sentenciaStore;

						} //public sql exception

					} // new CallableStatementCreator
					,new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																										DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();

							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
							}else{
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningún Resultado.");
							}
							return mensajeTransaccion;
						}// public

					}// CallableStatementCallback
					);


				if(mensajeBean ==  null){
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(999);
					throw new Exception("Fallo. El Procedimiento no Regreso Ningún Resultado.");
				}else if(mensajeBean.getNumero()!=0){
					throw new Exception(mensajeBean.getDescripcion());
				}


			} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de tipos de cedes por sucursal", e);
				mensajeBean.setDescripcion(e.getMessage());
				transaction.setRollbackOnly();

				}
				return mensajeBean;
			}
		});

		return mensaje;
	}// fin de alta de Sucursales

	/*Metodo para Modificar tasa de CEDES*/
	public MensajeTransaccionBean modificaTasas(final TasasCedesBean bean,final long Numtransaccion) {
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
								String query = "call TASASCEDESMOD(?,?,?,?,?,?,?,?,?,?, " +
										  						   "?,?,?,?,?,?,?,?,?,?, " +
										  						   "?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_TasaCedeID",Utileria.convierteEntero(bean.getTasaCedeID()));
								sentenciaStore.setInt("Par_TipoCedeID",bean.getTipoCedeID());
								sentenciaStore.setDouble("Par_MontoInferior",Utileria.convierteDoble(bean.getMontoInferior()));
								sentenciaStore.setDouble("Par_MontoSuperior",Utileria.convierteDoble(bean.getMontoSuperior()));
								sentenciaStore.setInt("Par_PlazoInferior",bean.getPlazoInferior());

								sentenciaStore.setInt("Par_PlazoSuperior",bean.getPlazoSuperior());
								sentenciaStore.setString("Par_Calificacion",bean.getCalificacion());
								sentenciaStore.setDouble("Par_TasaFija",Utileria.convierteDoble(bean.getTasaFija()));
								sentenciaStore.setInt("Par_TasaBase",Utileria.convierteEntero(bean.getTasaBase()));
								sentenciaStore.setDouble("Par_SobreTasa",Utileria.convierteDoble(bean.getSobreTasa()));

								sentenciaStore.setDouble("Par_PisoTasa",Utileria.convierteDoble(bean.getPisoTasa()));
								sentenciaStore.setDouble("Par_TechoTasa",Utileria.convierteDoble(bean.getTechoTasa()));
								sentenciaStore.setInt("Par_CalculoInteres",Utileria.convierteEntero(bean.getCalculoInteres()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",Numtransaccion);

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
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Modificación de Tasas de CEDES", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/*Metodo Para eliminar tasa de CEDES*/

	public MensajeTransaccionBean eliminaTasas(final TasasCedesBean bean, final int numBaja) {
	MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call TASASCEDESBAJ(?,?,?, ?,?,?,  ?,?,?,?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_TasaCedeID", Utileria.convierteEntero(bean.getTasaCedeID()));
							sentenciaStore.setInt("Par_TipoCedeID", bean.getTipoCedeID());
							sentenciaStore.setInt("Par_NumBaj",numBaja);

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TASASCEDESBAJ(" + sentenciaStore.toString() + ")");

							return sentenciaStore;

						} //public sql exception

					} // new CallableStatementCreator
					,new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																										DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();

							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
							}else{
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningún Resultado.");
							}
							return mensajeTransaccion;
						}// public

					}// CallableStatementCallback
					);


				if(mensajeBean ==  null){
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(999);
					throw new Exception("Fallo. El Procedimiento no Regreso Ningún Resultado.");
				}else if(mensajeBean.getNumero()!=0){
					throw new Exception(mensajeBean.getDescripcion());
				}


			} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Baja de Tasas de cedes.", e);
				mensajeBean.setDescripcion(e.getMessage());
				transaction.setRollbackOnly();

				}
				return mensajeBean;
			}
		});

		return mensaje;
	}// fin


/*	public MensajeTransaccionBean eliminaTasas(TasasCedesBean bean, int numBaja) {
		String query = "call TASASCEDESBAJ(?,?,?,?,?, ?,?,?,?,?);";

		Object[] parametros = {
				bean.getTasaCedeID(),
				bean.getTipoCedeID(),
				numBaja,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"TasasCedesDAO.eliminaTasas",
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TASASCEDESBAJ(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
				mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
				mensaje.setDescripcion(resultSet.getString(2));
				mensaje.setNombreControl(resultSet.getString(3));
				return mensaje;
			}
		});

		return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
	}*/

	public TasasCedesBean consultaPrincipal(TasasCedesBean tasasCedesBean, int tipoConsulta){
		String query = "call TASASCEDESCON(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?);";
		Object[] parametros = { tasasCedesBean.getTipoCedeID(),
								tasasCedesBean.getTasaCedeID(),
								tasasCedesBean.getMontoInferior(),
								tasasCedesBean.getMontoSuperior(),
								tasasCedesBean.getPlazoInferior(),
								tasasCedesBean.getPlazoSuperior(),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"TasasCedesDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};



		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TASASCEDESCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TasasCedesBean tasasCedesBean = new TasasCedesBean();
				tasasCedesBean.setTasaCedeID(resultSet.getString(1));
				tasasCedesBean.setTipoCedeID(Utileria.convierteEntero(resultSet.getString(2)));
				tasasCedesBean.setMontoID(resultSet.getString(3));
				tasasCedesBean.setPlazoID(resultSet.getString(4));
				tasasCedesBean.setCalificacion(resultSet.getString(5));
				tasasCedesBean.setTasaFija(resultSet.getString(6));
				tasasCedesBean.setTasaBase(resultSet.getString(7));
				tasasCedesBean.setSobreTasa(resultSet.getString(8));
				tasasCedesBean.setPisoTasa(resultSet.getString(9));
				tasasCedesBean.setTechoTasa(resultSet.getString(10));
				tasasCedesBean.setCalculoInteres(resultSet.getString(11));
				return tasasCedesBean;
			}
		});
		return matches.size() > 0 ? (TasasCedesBean) matches.get(0) : null;
	}

	public TasasCedesBean consultaTasaVariable(TasasCedesBean tasasCedesBean, int tipoConsulta){
		String query = "call TASASCEDESCON(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?);";
		Object[] parametros = { tasasCedesBean.getTipoCedeID(),
								Constantes.ENTERO_CERO,
								tasasCedesBean.getMonto(),
								Constantes.DOUBLE_VACIO,
								tasasCedesBean.getPlazo(),
								Constantes.ENTERO_CERO,
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"TasasCedesDAO.consultaTasaVariable",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TASASCEDESCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				TasasCedesBean tasasCedesBean = new TasasCedesBean();
				tasasCedesBean.setTipoCedeID(Utileria.convierteEntero(resultSet.getString("TasaBase")));
				tasasCedesBean.setCalculoInteres(resultSet.getString("CalculoInteres"));
				tasasCedesBean.setNombreTasaBase(resultSet.getString("NombreTasaBase"));

				return tasasCedesBean;
			}
		});
		return matches.size() > 0 ? (TasasCedesBean) matches.get(0) : null;
	}




	public TasasCedesBean consultaTasa(TasasCedesBean tasasCedesBean){
		String query = "call TASASCEDESCAL(?,?,?,?,?);";


		Object[] parametros = {
				tasasCedesBean.getTipoCedeID(),
				tasasCedesBean.getPlazo(),
				tasasCedesBean.getMonto(),
				tasasCedesBean.getCalificacion(),
				tasasCedesBean.getSucursalID()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TASASCEDESCAL(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TasasCedesBean tasasCedesBean = new TasasCedesBean();
				tasasCedesBean.setTasaAnualizada(resultSet.getString("TasaAnualizada"));
				tasasCedesBean.setTasaBase(resultSet.getString("Var_TasaBase"));
				tasasCedesBean.setCalculoInteres(resultSet.getString("Var_CalculoInteres"));
				tasasCedesBean.setSobreTasa(resultSet.getString(4));
				tasasCedesBean.setPisoTasa(resultSet.getString(5));
				tasasCedesBean.setTechoTasa(resultSet.getString(6));
				tasasCedesBean.setValorGat(resultSet.getString(7));
				tasasCedesBean.setValorGatReal(resultSet.getString(8));
				return tasasCedesBean;
			}
		});
		return matches.size() > 0 ? (TasasCedesBean)  matches.get(0) : null;
	}




	/*Validaciones de tasas*/
	public MensajeTransaccionBean validaciones(final TasasCedesBean bean, final  TasasCedesBean beanD, final long Numtransaccion) {
	MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
				String query = "call VALIDATASASCEDES(?,?,?,?,?, ?,?,?,?,?,  ?,?,?,   ?,?,?,?,?,?,?);";

				CallableStatement sentenciaStore = arg0.prepareCall(query);
					sentenciaStore.setInt("Par_TasaID", Utileria.convierteEntero(bean.getTasaID()));
					sentenciaStore.setInt("Par_TipoProdID", Utileria.convierteEntero(bean.getTipoProdID()));
					sentenciaStore.setDouble("Par_MontoInferior",Utileria.convierteDoble(bean.getMontoInferior()));
					sentenciaStore.setDouble("Par_MontoSuperior",Utileria.convierteDoble(bean.getMontoSuperior()));
					sentenciaStore.setInt("Par_PlazoInferior",bean.getPlazoInferior());

					sentenciaStore.setInt("Par_PlazoSuperior",bean.getPlazoSuperior());
					sentenciaStore.setString("Par_Calificacion",bean.getCalificacion());
					sentenciaStore.setInt("Par_SucursalID",Utileria.convierteEntero(beanD.getSucursalID()));
					sentenciaStore.setInt("Par_TipoInstrumento",Utileria.convierteEntero(bean.getTipoInstrumentoID()));
					sentenciaStore.setString("Par_TipoPersona", bean.getTipoPersona());

					sentenciaStore.setString("Par_Salida",salidaPantalla);
					sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
					sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

					sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
					sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());
					sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
					sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
					sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
					sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
					sentenciaStore.setLong("Aud_NumTransaccion",Numtransaccion);

					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
					return sentenciaStore;

						} //public sql exception

					} // new CallableStatementCreator
					,new CallableStatementCallback() {
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
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningún Resultado.");
							}
							return mensajeTransaccion;
						}// public

					}// CallableStatementCallback
					);


				if(mensajeBean ==  null){
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(999);
					throw new Exception("Fallo. El Procedimiento no Regreso Ningún Resultado.");
				}else if(mensajeBean.getNumero()!=0){
					throw new Exception(mensajeBean.getDescripcion());
				}


			} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Validaciones de Tasas de CEDES", e);
				mensajeBean.setDescripcion(e.getMessage());
				transaction.setRollbackOnly();

				}
				return mensajeBean;
			}
		});

		return mensaje;
	}// fin


	/*Lista principal de tasas*/
	public List listaPrincipal(TasasCedesBean tasasCedesBean, int tipoLista){
		String query = "call TASASCEDESLIS(?,?,?,? ,?,?,? ,?,?,?);";
		Object[] parametros = {
				tasasCedesBean.getTipoCedeID(),
				tipoLista,
				Constantes.STRING_VACIO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"TasasCedesDAO.listaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TASASCEDESLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TasasCedesBean tasasCedesBean = new TasasCedesBean();
				tasasCedesBean.setTasaCedeID(resultSet.getString(1));
				tasasCedesBean.setMontoID(resultSet.getString(2));
				tasasCedesBean.setPlazoID(resultSet.getString(3));
				tasasCedesBean.setCalificacion(resultSet.getString(4));
				return tasasCedesBean;
			}
		});
		return matches;
	}

	/*Lista principal de tasas*/
	public List listaReporte(TasasCedesBean tasasCedesBean, int tipoLista){
		String query = "call TASASCEDESLIS(?,?,?,? ,?,?,? ,?,?,?);";
		Object[] parametros = {
				tasasCedesBean.getTipoCedeID(),
				tipoLista,
				tasasCedesBean.getPlazoID(),
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"TasasCedesDAO.listaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TASASCEDESLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TasasCedesBean tasasCedesBean = new TasasCedesBean();
				tasasCedesBean.setTasaCedeID(resultSet.getString("TasaCedeID"));
				tasasCedesBean.setPlazoID(resultSet.getString("Plazos"));
				tasasCedesBean.setMontosConTasa(resultSet.getString("MontosConTasa"));
				tasasCedesBean.setTasaFija(resultSet.getString("TasaFija"));
				return tasasCedesBean;
			}
		});
		return matches;
	}

	/*Lista Grid de tasas*/
	public List listaGrid(TasasCedesBean tasasCedesBean, int tipoLista){
		String query = "call TASASCEDESLIS(?,?,?,? ,?,?,? ,?,?,?);";
		Object[] parametros = {
				tasasCedesBean.getTipoCedeID(),
				tipoLista,
				Constantes.STRING_VACIO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"TasasCedesDAO.listaGrid",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TASASCEDESLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TasasCedesBean tasasCedesBean = new TasasCedesBean();
				tasasCedesBean.setTasaCedeID(resultSet.getString(1));
				tasasCedesBean.setPlazoID(resultSet.getString(2));
				tasasCedesBean.setMontoID(resultSet.getString(3));
				tasasCedesBean.setTasaFija(resultSet.getString(4));
				tasasCedesBean.setTasaBase(resultSet.getString(5));
				tasasCedesBean.setSobreTasa(resultSet.getString(6));
				tasasCedesBean.setPisoTasa(resultSet.getString(7));
				tasasCedesBean.setTechoTasa(resultSet.getString(8));
				tasasCedesBean.setCalificacion(resultSet.getString(9));
				return tasasCedesBean;
			}
		});
		return matches;
	}


}
