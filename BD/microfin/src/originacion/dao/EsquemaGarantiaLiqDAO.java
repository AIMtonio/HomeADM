package originacion.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

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

import originacion.bean.EsquemaGarantiaLiqBean;

public class EsquemaGarantiaLiqDAO extends BaseDAO{

	public EsquemaGarantiaLiqDAO(){
		super();
	}


	/*=============================== METODOS ==================================*/

	/* da de alta un esquema de garantia liquida para un producto de credito */
	public MensajeTransaccionBean alta(final EsquemaGarantiaLiqBean bean, final String esPrimero) {
	MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
				String query = "call ESQUEMAGARANTIALIQALT(	  ?,?,?,?,?," +
															" ?,?,?,?,?," +
															" ?,?,?,?,?," +
															" ?,?);";

				CallableStatement sentenciaStore = arg0.prepareCall(query);

					sentenciaStore.setInt("Par_ProducCreditoID", Utileria.convierteEntero(bean.getProducCreditoID()));
					sentenciaStore.setString("Par_Clasificacion",bean.getClasificacion());
					sentenciaStore.setDouble("Par_LimiteInferior", Utileria.convierteDoble(bean.getLimiteInferior()));
					sentenciaStore.setDouble("Par_LimiteSuperior", Utileria.convierteDoble(bean.getLimiteSuperior()));
					sentenciaStore.setDouble("Par_Porcentaje", Utileria.convierteDoble(bean.getPorcentaje()));

					sentenciaStore.setDouble("Par_PorcBonifFOGA", Utileria.convierteDoble(bean.getPorcBonificacionFOGA()));


					sentenciaStore.setString("Par_EsPrimero",esPrimero);

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


							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ESQUEMAGARANTIALIQALT(" + sentenciaStore.toString() + ")");

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de Esquema Garantía Líquida", e);
				mensajeBean.setDescripcion(e.getMessage());
				transaction.setRollbackOnly();

				}
				return mensajeBean;
			}
		});

		return mensaje;
	}// fin de alta


	/**
	 * Da de alta un esquema de garantía FOGAFI para un producto de crédito
	 * @param bean
	 * @param esPrimero
	 * @return
	 */
	public MensajeTransaccionBean altaFOGAFI(final EsquemaGarantiaLiqBean bean, final String esPrimero) {
	MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
				String query = "call ESQUEMAGARFOGAFIALT(	  ?,?,?,?,?," +
															" ?,?,?,?,?," +
															" ?,?,?,?,?," +
															" ?,?);";

				CallableStatement sentenciaStore = arg0.prepareCall(query);

					sentenciaStore.setInt("Par_ProducCreditoID", Utileria.convierteEntero(bean.getProducCreditoID()));
					sentenciaStore.setString("Par_ClasificacionFOGAFI",bean.getClasificacionFOGAFI());
					sentenciaStore.setDouble("Par_LimiteInferiorFOGAFI", Utileria.convierteDoble(bean.getLimiteInferiorFOGAFI()));
					sentenciaStore.setDouble("Par_LimiteSuperiorFOGAFI", Utileria.convierteDoble(bean.getLimiteSuperiorFOGAFI()));
					sentenciaStore.setDouble("Par_PorcentajeFOGAFI", Utileria.convierteDoble(bean.getPorcentajeFOGAFI()));

					sentenciaStore.setDouble("Par_PorcBonifFOGAFI", Utileria.convierteDoble(bean.getPorcBonificacionFOGAFI()));
					sentenciaStore.setString("Par_EsPrimero",esPrimero);

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


							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ESQUEMAGARFOGAFIALT(" + sentenciaStore.toString() + ")");

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de Esquema Garantía Líquida", e);
				mensajeBean.setDescripcion(e.getMessage());
				transaction.setRollbackOnly();

				}
				return mensajeBean;
			}
		});

		return mensaje;
	}// fin de alta


	/* Metodo para dar de baja todos los esquemas de garantia liquida para un producto de credito */
	public MensajeTransaccionBean baja(final EsquemaGarantiaLiqBean bean) {
	MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
				String query = "call ESQUEMAGARANTIALIQBAJ(?,?,?,?,?, ?,?,?,?,?, ?);";

				CallableStatement sentenciaStore = arg0.prepareCall(query);
					sentenciaStore.setInt("Par_ProducCreditoID", Utileria.convierteEntero(bean.getProducCreditoID()));

					sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
					sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
					sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

					sentenciaStore.setInt("Par_EmpresaID",Constantes.ENTERO_CERO);
					sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
					sentenciaStore.setString("Aud_FechaActual", Constantes.FECHA_VACIA);
					sentenciaStore.setString("Aud_DireccionIP",Constantes.STRING_VACIO);
					sentenciaStore.setString("Aud_ProgramaID","ClienteArchivosDAO");
					sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
					sentenciaStore.setLong("Aud_NumTransaccion",Constantes.ENTERO_CERO);


							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ESQUEMAGARANTIALIQBAJ(" + sentenciaStore.toString() + ")");

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de esquemas de garantía líquida.", e);
				mensajeBean.setDescripcion(e.getMessage());
				transaction.setRollbackOnly();

				}
				return mensajeBean;
			}
		});

		return mensaje;
	}// fin de metodo baja


	/**
	 * Metodo que da de baja el Esquema de Garantía FOGAFI de un Producto de Crédito
	 * @param bean
	 * @return
	 */
	public MensajeTransaccionBean bajaFOGAFI(final EsquemaGarantiaLiqBean bean) {
	MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
				String query = "call ESQUEMAGARFOGAFIBAJ(?,?,?,?,?, ?,?,?,?,?, ?);";

				CallableStatement sentenciaStore = arg0.prepareCall(query);
					sentenciaStore.setInt("Par_ProducCreditoID", Utileria.convierteEntero(bean.getProducCreditoID()));

					sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
					sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
					sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

					sentenciaStore.setInt("Par_EmpresaID",Constantes.ENTERO_CERO);
					sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
					sentenciaStore.setString("Aud_FechaActual", Constantes.FECHA_VACIA);
					sentenciaStore.setString("Aud_DireccionIP",Constantes.STRING_VACIO);
					sentenciaStore.setString("Aud_ProgramaID","ClienteArchivosDAO");
					sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
					sentenciaStore.setLong("Aud_NumTransaccion",Constantes.ENTERO_CERO);


							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ESQUEMAGARFOGAFIBAJ(" + sentenciaStore.toString() + ")");

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de esquemas de garantía líquida.", e);
				mensajeBean.setDescripcion(e.getMessage());
				transaction.setRollbackOnly();

				}
				return mensajeBean;
			}
		});

		return mensaje;
	}// fin de metodo baja

	/* Actualiza un producto de credito que no requiere garantia liquida */
	public MensajeTransaccionBean actualiza(final EsquemaGarantiaLiqBean bean) {
	MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
				String query = "call ESQUEMAGARANTIALIQACT(?,?,?,?,?," +
															" ?,?,?,?,?," +
															" ?,?,?,?,?);";

				CallableStatement sentenciaStore = arg0.prepareCall(query);

					sentenciaStore.setInt("Par_ProducCreditoID", Utileria.convierteEntero(bean.getProducCreditoID()));
					sentenciaStore.setString("Par_GarantiaLiquida",bean.getGarantiaLiquida());
					sentenciaStore.setString("Par_LiberarGaranLiq",bean.getLiberarGaranLiq());

					sentenciaStore.setString("Par_BonificacionFOGA",bean.getBonificacionFOGA());
					sentenciaStore.setString("Par_DesbloqAutFOGA",bean.getDesbloqAutFOGA());

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


							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ESQUEMAGARANTIALIQACT(" + sentenciaStore.toString() + ")");

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualización de producto de crédito que no requiere garantía líquida", e);
				mensajeBean.setDescripcion(e.getMessage());
				transaction.setRollbackOnly();

				}
				return mensajeBean;
			}
		});

		return mensaje;
	}// fin de actualizacion


	/**
	 * Actualiza un producto de crédito a que no requiere garantía FOGAFI
	 * @param bean
	 * @return
	 */
	public MensajeTransaccionBean actualizaFOGAFI(final EsquemaGarantiaLiqBean bean) {
	MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
				String query = "call ESQUEMAGARFOGAFIACT(?,?,?,?,?," +
															" ?,?,?,?,?," +
															" ?,?,?,?,?," +
															" ?,?);";

				CallableStatement sentenciaStore = arg0.prepareCall(query);

					sentenciaStore.setInt("Par_ProducCreditoID", Utileria.convierteEntero(bean.getProducCreditoID()));
					sentenciaStore.setString("Par_GarantiaLiquida",bean.getGarantiaLiquida());
					sentenciaStore.setString("Par_LiberarGaranLiq",bean.getLiberarGaranLiq());
					sentenciaStore.setString("Par_GarantiaFOGAFI",bean.getGarantiaFOGAFI());
					sentenciaStore.setString("Par_ModalidadFOGAFI",bean.getModalidadFOGAFI());

					sentenciaStore.setString("Par_BonificacionFOGAFI",bean.getBonificacionFOGAFI());
					sentenciaStore.setString("Par_DesbloqAutFOGAFI",bean.getDesbloqAutFOGAFI());


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


							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ESQUEMAGARFOGAFIACT(" + sentenciaStore.toString() + ")");

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualización de producto de crédito que no requiere garantía FOGAFI", e);
				mensajeBean.setDescripcion(e.getMessage());
				transaction.setRollbackOnly();

				}
				return mensajeBean;
			}
		});

		return mensaje;
	}// fin de actualizacion

	/* Consulta los datos de un esquema de garantia liquida para un producto de credito */
	public EsquemaGarantiaLiqBean consultaPrincipal(EsquemaGarantiaLiqBean bean, int tipoConsulta) {
		EsquemaGarantiaLiqBean esquema = new EsquemaGarantiaLiqBean();
		try{
			String query = "call ESQUEMAGARANTIALIQCON(?,?,?,?,?,  ?,?,?,?,?,   ?,?);";
			Object[] parametros = { Utileria.convierteEntero(bean.getProducCreditoID()),
									Utileria.convierteEntero(bean.getClienteID()),
									bean.getCalificacion(),
									Utileria.convierteDoble(bean.getMontoSolici()),
									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"EsquemaGarantiaLiqDAO.consultaPrincipal",

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ESQUEMAGARANTIALIQCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					EsquemaGarantiaLiqBean bean = new EsquemaGarantiaLiqBean();

					bean.setEsquemaGarantiaLiqID(resultSet.getString("EsquemaGarantiaLiqID"));
					bean.setProducCreditoID(resultSet.getString("ProducCreditoID"));
					bean.setClasificacion(resultSet.getString("Clasificacion"));
					bean.setLimiteInferior(resultSet.getString("LimiteInferior"));
					bean.setLimiteSuperior(resultSet.getString("LimiteSuperior"));
					bean.setPorcentaje(resultSet.getString("Porcentaje"));

					return bean;
				}
			});
			esquema =  matches.size() > 0 ? (EsquemaGarantiaLiqBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
		}
		return esquema;
	}// fin de consulta


	/**
	 * Consulta la configuración del Esquema de Garantía FOGAFI de un Producto de Crédito
	 * @param bean
	 * @param tipoConsulta
	 * @return
	 */
	public EsquemaGarantiaLiqBean consultaPrincipalFOGAFI(EsquemaGarantiaLiqBean bean, int tipoConsulta) {
		EsquemaGarantiaLiqBean esquema = new EsquemaGarantiaLiqBean();
		try{
			String query = "call ESQUEMAGARFOGAFICON(?,?,?,?,?,  ?,?,?,?,?,   ?,?);";
			Object[] parametros = { Utileria.convierteEntero(bean.getProducCreditoID()),
									Utileria.convierteEntero(bean.getClienteID()),
									bean.getCalificacion(),
									Utileria.convierteDoble(bean.getMontoSolici()),
									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"EsquemaGarantiaLiqDAO.consultaPrincipalFOGAFI",

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ESQUEMAGARFOGAFICON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					EsquemaGarantiaLiqBean bean = new EsquemaGarantiaLiqBean();

					bean.setEsquemaGarFOGAFIID(resultSet.getString("EsquemaGarFogafiID"));
					bean.setProducCreditoID(resultSet.getString("ProducCreditoID"));
					bean.setClasificacion(resultSet.getString("Clasificacion"));
					bean.setLimiteInferior(resultSet.getString("LimiteInferior"));
					bean.setLimiteSuperior(resultSet.getString("LimiteSuperior"));
					bean.setPorcentajeFOGAFI(resultSet.getString("Porcentaje"));

					return bean;
				}
			});
			esquema =  matches.size() > 0 ? (EsquemaGarantiaLiqBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
		}
		return esquema;
	}// fin de consultaPrincipalFOGAFI


	/* Lista esquemas de garantia liquida para un producto de credito (grid) */
	public List listaPorProducCredito(EsquemaGarantiaLiqBean bean, int tipoLista) {
		String query = "call ESQUEMAGARANTIALIQLIS(?,?,?,?,  ?,?,?,?,?);";
		Object[] parametros = {		Utileria.convierteEntero(bean.getProducCreditoID()),
									tipoLista,
									Constantes.ENTERO_CERO,		//	empresaID
									Constantes.ENTERO_CERO,		//	aud_usuario
									Constantes.FECHA_VACIA,		//	fechaActual
									Constantes.STRING_VACIO,	// 	direccionIP
									Constantes.STRING_VACIO, 	//	programaID
									Constantes.ENTERO_CERO,		// 	sucursal
									Constantes.ENTERO_CERO};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ESQUEMAGARANTIALIQLIS(" + Arrays.toString(parametros) +")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {

			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				EsquemaGarantiaLiqBean bean = new EsquemaGarantiaLiqBean();

				bean.setEsquemaGarantiaLiqID(resultSet.getString("EsquemaGarantiaLiqID"));
				bean.setProducCreditoID(resultSet.getString("ProducCreditoID"));
				bean.setClasificacion(resultSet.getString("Clasificacion"));
				bean.setLimiteInferior(resultSet.getString("LimiteInferior"));
				bean.setLimiteSuperior(resultSet.getString("LimiteSuperior"));
				bean.setPorcentaje(resultSet.getString("Porcentaje"));
				bean.setPorcBonificacionFOGA(resultSet.getString("BonificacionFOGA"));

				return bean;
			}
		});

		return matches;
	}// fin de lista


	/**
	 * Lista del Esquema de Garantia Liquida para un producto de crédito(Se muestra en el grid)
	 * @param bean
	 * @param tipoLista
	 * @return
	 */
	public List listaPorProdCredFOGAFI(EsquemaGarantiaLiqBean bean, int tipoLista) {
		String query = "call ESQUEMAGARFOGAFILIS(?,?,?,?,  ?,?,?,?,?);";
		Object[] parametros = {		Utileria.convierteEntero(bean.getProducCreditoID()),
									tipoLista,

									Constantes.ENTERO_CERO,		//	EmpresaID
									Constantes.ENTERO_CERO,		//	Aud_usuario
									Constantes.FECHA_VACIA,		//	FechaActual
									Constantes.STRING_VACIO,	// 	DireccionIP
									Constantes.STRING_VACIO, 	//	ProgramaID
									Constantes.ENTERO_CERO,		// 	Sucursal
									Constantes.ENTERO_CERO};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ESQUEMAGARFOGAFILIS(" + Arrays.toString(parametros) +")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {

			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				EsquemaGarantiaLiqBean bean = new EsquemaGarantiaLiqBean();

				bean.setEsquemaGarFOGAFIID(resultSet.getString("EsquemaGarFogafiID"));
				bean.setProducCreditoID(resultSet.getString("ProducCreditoID"));
				bean.setClasificacionFOGAFI(resultSet.getString("Clasificacion"));
				bean.setLimiteInferiorFOGAFI(resultSet.getString("LimiteInferior"));
				bean.setLimiteSuperiorFOGAFI(resultSet.getString("LimiteSuperior"));
				bean.setPorcentajeFOGAFI(resultSet.getString("Porcentaje"));
				bean.setPorcBonificacionFOGAFI(resultSet.getString("BonificacionFOGAFI"));

				return bean;
			}
		});

		return matches;
	}// fin de lista


	/**
	 * Método que actualiza la configuración de Garantía Líquida y da de alta su Esquema
	 * @param listaEsquemas
	 * @return
	 */
	public MensajeTransaccionBean procesarAlta(final List listaEsquemas) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					 EsquemaGarantiaLiqBean bean;
					 EsquemaGarantiaLiqBean beanAct;

					 // Se obtienen los datos para actualizar el producto de crédito con las parametrizaciones del cobro de garantia liquida
					 beanAct = (EsquemaGarantiaLiqBean)listaEsquemas.get(0);

					if(listaEsquemas!=null){

						// Se actualiza la parametrización del esquema de garantía en el producto de crédito.
						actualiza(beanAct);
						actualizaFOGAFI(beanAct);
						baja(beanAct);
						// Si el producto de crédito no cobra Garantía Liquida(FOGA), se eliminan todos su esquema configurado.
						if(beanAct.getGarantiaFOGAFI() != null){
							if(beanAct.getGarantiaFOGAFI().equalsIgnoreCase("N")){
							bajaFOGAFI(beanAct);
							}
						}

						for(int i=0; i<listaEsquemas.size(); i++){
							/* obtenemos un bean de la lista */
							bean = (EsquemaGarantiaLiqBean)listaEsquemas.get(i);

								/*Si es el primero eliminara todos los registros de la tabla para insertar todos de nuevo */
								if(i==0){
									mensajeBean = alta(bean, "S");
								}
								else{
									mensajeBean = alta(bean, "N");
								}

								if(mensajeBean.getNumero()!=0){
									throw new Exception(mensajeBean.getDescripcion());
								}
						}
					}
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en procesar alta de esquema de garantía líquida", e);
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

	}// fin de modificar

	/**
	 * Método que actualiza la configuración de Garantía FOGAFI y da de alta su Esquema
	 * @param listaEsquemas
	 * @return
	 */
	public MensajeTransaccionBean procesarAltaFOGAFI(final List listaEsquemas) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					 EsquemaGarantiaLiqBean bean;
					 EsquemaGarantiaLiqBean beanAct;

					 // Se obtienen los datos para actualizar el producto de crédito con las parametrizaciones del cobro de garantia liquida
					 beanAct = (EsquemaGarantiaLiqBean)listaEsquemas.get(0);

					if(listaEsquemas!=null){
						// Se actualiza la parametrización del esquema de garantía en el producto de crédito.
						actualiza(beanAct);
						actualizaFOGAFI(beanAct);
						bajaFOGAFI(beanAct);

						// Si el producto de crédito no cobra Garantía Liquida(FOGA), se eliminan todos su esquema configurado.
						if(beanAct.getGarantiaLiquida() != null){
							if(beanAct.getGarantiaLiquida().equalsIgnoreCase("N")){
								baja(beanAct);
							}
						}

						for(int i=0; i<listaEsquemas.size(); i++){
							/* obtenemos un bean de la lista */
							bean = (EsquemaGarantiaLiqBean)listaEsquemas.get(i);

								/*Si es el primero eliminara todos los registros de la tabla para insertar todos de nuevo */
								if(i==0){
									mensajeBean = altaFOGAFI(bean, "S");
								}
								else{
									mensajeBean = altaFOGAFI(bean, "N");
								}
								if(mensajeBean.getNumero()!=0){
									throw new Exception(mensajeBean.getDescripcion());
								}
						}
					}
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en procesar alta de esquema de garantía líquida", e);
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

	}


}// fin de la clase
