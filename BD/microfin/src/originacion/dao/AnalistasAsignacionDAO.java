package originacion.dao;



import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
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
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import originacion.bean.AnalistasAsignacionBean;

public class AnalistasAsignacionDAO extends BaseDAO {

	public AnalistasAsignacionDAO() {
		super();
	}


	// ------------------ Transacciones ------------------------------------------

	public MensajeTransaccionBean alta(final AnalistasAsignacionBean analistasAsignacionBean, final long NumeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();


		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

								String query = "call ANALISTASASIGNACIONALT("+
										"?,?,?,?,?  ," +
										"?,?,?,?,?	," +
										"?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								try{
								sentenciaStore.setInt("Par_UsuarioID",Utileria.convierteEntero(analistasAsignacionBean.getUsuarioID()));
								sentenciaStore.setInt("Par_TipoAsignacionID",Utileria.convierteEntero(analistasAsignacionBean.getTipoAsignacionID()));
								sentenciaStore.setInt("Par_ProductoID",Utileria.convierteEntero(analistasAsignacionBean.getProductoID()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID","CreditosDAO");

								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",NumeroTransaccion);
								loggerSAFI.info(sentenciaStore.toString());
								return sentenciaStore;
								} catch(Exception ex){
									ex.printStackTrace();
									loggerSAFI.info(sentenciaStore.toString());
									return null;
								}

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
					loggerSAFI.error("error en alta de asignacion de analista", e);
				}
				return mensajeBean;
			}
		});

		return mensaje;
	}

   private final static String salidaPantalla = "S";

   public MensajeTransaccionBean altaHistorico(final AnalistasAsignacionBean analistasAsignacionBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call HISANALISTASASIGNACIONALT(?,?,?,?,?,"
																			+ "?,?,?,?,?,"
																			+ "?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);


									sentenciaStore.setInt("Par_TipoAsignacionID",Utileria.convierteEntero(analistasAsignacionBean.getTipoAsignacionID()));
									sentenciaStore.setInt("Par_ProductoID",Utileria.convierteEntero(analistasAsignacionBean.getProductoID()));


									sentenciaStore.setString("Par_Salida",salidaPantalla);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									//Parametros de Auditoria
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
										mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .AnalistasAsignacionDAO.altaHistorico");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}

									return mensajeTransaccion;
								}
							}
							);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .AnalistasAsignacionDAO.altaHistorico");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta historico catalogo asignacion analista de Credito ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/* LISTA DE ASIGNACION DE ANALISTAS */
   public List<AnalistasAsignacionBean> lista(AnalistasAsignacionBean analistasAsignacionBean,int tipoLista) {
		// Query con el Store Procedure
		String query = "call ANALISTASASIGNACIONLIS(?,?,?,"
										   +"?,?,?,?,?,?,?);";

		Object[] parametros = {
			tipoLista,
			analistasAsignacionBean.getTipoAsignacionID(),
			analistasAsignacionBean.getProductoID(),
			parametrosAuditoriaBean.getEmpresaID(),
			parametrosAuditoriaBean.getUsuario(),
			parametrosAuditoriaBean.getFecha(),
			parametrosAuditoriaBean.getDireccionIP(),
			"AnalistasAsignacionDAO.lista",
			parametrosAuditoriaBean.getSucursal(),
			Constantes.ENTERO_CERO
		};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ANALISTASASIGNACIONLIS(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {

				AnalistasAsignacionBean analistasAsig=new AnalistasAsignacionBean();
				analistasAsig.setClave(resultSet.getString("Clave"));
				analistasAsig.setNombreCompleto(resultSet.getString("NombreCompleto"));
				analistasAsig.setUsuarioID(resultSet.getString("UsuarioID"));
				analistasAsig.setProductoID(resultSet.getString("ProductoID"));




				return analistasAsig;
			}
		});

		return matches;
	}


   public MensajeTransaccionBean grabaDetalle(final AnalistasAsignacionBean analistasAsignacionBean,final List<AnalistasAsignacionBean> listaDetalle) {
		transaccionDAO.generaNumeroTransaccion();
		MensajeTransaccionBean mensajeTransaccion = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try{
					mensajeBean=altaHistorico(analistasAsignacionBean);
					if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
					for(AnalistasAsignacionBean detalle : listaDetalle){
						mensajeBean = alta(detalle, parametrosAuditoriaBean.getNumeroTransaccion());
						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
				}catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					mensajeBean.setNombreControl("grabar");
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en grabar detalle: ", e);
					return mensajeBean;
				}
				return mensajeBean;
			}
		});
		return mensajeTransaccion;
	}


   /* LISTA COMBO TIPOS DE ACTIVOS */
   public List listaComboCatalogoAsig(int tipoLista) {
		// Query con el Store Procedure
		String query = "call CATALOGOASIGNACIONLIS(?,"
										   +"?,?,?,?,?,?,?);";

		Object[] parametros = {
			tipoLista,

			parametrosAuditoriaBean.getEmpresaID(),
			parametrosAuditoriaBean.getUsuario(),
			parametrosAuditoriaBean.getFecha(),
			parametrosAuditoriaBean.getDireccionIP(),
			"analistasAsignacionesDAO.listaComboCatalogoAsig",
			parametrosAuditoriaBean.getSucursal(),
			Constantes.ENTERO_CERO
		};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATALOGOASIGNACIONLIS(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {

				AnalistasAsignacionBean bean = new AnalistasAsignacionBean();

				bean.setTipoAsignacionID(resultSet.getString("TipoAsignacionID"));
				bean.setDescripcion(resultSet.getString("Descripcion"));

				return bean;
			}
		});

		return matches;
	}

   @SuppressWarnings("unchecked")
public List<AnalistasAsignacionBean> listaReporte(final AnalistasAsignacionBean analistasAsignacionBean){
		List<AnalistasAsignacionBean> ListaResultado=null;
		int tipoReporte = 1;
		try{
		String query = "CALL PRODUCTIVIDADREP(?,?,?," +
												" ?,?,?,?,?," +
												" ?,?)";
		Object[] parametros ={
				Utileria.convierteEntero(analistasAsignacionBean.getUsuarioID()),
				Utileria.convierteFecha(analistasAsignacionBean.getFechaInicio()),
				Utileria.convierteFecha(analistasAsignacionBean.getFechaFin()),

	    		parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),

				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL PRODUCTIVIDADREP(  " + Arrays.toString(parametros) + ");");
		List<AnalistasAsignacionBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				AnalistasAsignacionBean analistasAsigBean= new AnalistasAsignacionBean();

				analistasAsigBean.setUsuario(resultSet.getString("UsuarioID"));
				analistasAsigBean.setNombre(resultSet.getString("Nombre"));
				analistasAsigBean.setAsignadas(resultSet.getString("Asignadas"));
				analistasAsigBean.setEnRevision(resultSet.getString("EnRevision"));
				analistasAsigBean.setDevoluciones(resultSet.getString("Devoluciones"));
				analistasAsigBean.setCanceladas(resultSet.getString("Canceladas"));
				analistasAsigBean.setRechazadas(resultSet.getString("Rechazadas"));
				analistasAsigBean.setAutorizadas(resultSet.getString("Autorizadas"));
				analistasAsigBean.setPendGlobal(resultSet.getString("PendGlobal"));
				analistasAsigBean.setAutGlobal(resultSet.getString("AutGlobal"));
				analistasAsigBean.setPendIndv(resultSet.getString("PendIndv"));
				analistasAsigBean.setTerminadas(resultSet.getString("Terminadas"));

				analistasAsigBean.setTotalAsignadas(resultSet.getString("TotalAsignadas"));
				analistasAsigBean.setTotalEnRevision(resultSet.getString("TotalEnRevision"));
				analistasAsigBean.setTotalDevueltas(resultSet.getString("TotalDevueltas"));
				analistasAsigBean.setTotalCanceladas(resultSet.getString("TotalCanceladas"));
				analistasAsigBean.setTotalRechazadas(resultSet.getString("TotalRechazadas"));
				analistasAsigBean.setTotalAutorizadas(resultSet.getString("TotalAutorizadas"));
				analistasAsigBean.setTotalPorcPendGlobal(resultSet.getString("TotalPorcPendGlobal"));
				analistasAsigBean.setTotalAutoriGlobal(resultSet.getString("TotalAutoriGlobal"));


				return analistasAsigBean ;
			}
		});
		ListaResultado= matches;
		}catch(Exception e){
			 e.printStackTrace();
			 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en reporte asignacion de solicitud de credito: ", e);
		}
		return ListaResultado;
	}// fin lista report


}
