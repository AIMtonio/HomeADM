package contabilidad.dao;

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
import contabilidad.bean.FrecTimbradoProducBean;
import tarjetas.bean.TarDebGiroxTipoCliCorpBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class FrecTimbradoProducDAO extends BaseDAO  {
	public FrecTimbradoProducDAO() {
		super();
	}

	public MensajeTransaccionBean grabaFrecuProduc(final FrecTimbradoProducBean frecTimbradoProducBean,final List listaFrecProduc) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					FrecTimbradoProducBean frecBean;
					mensajeBean = bajaFrecuenciaProdu(frecTimbradoProducBean);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}


					for(int i=0; i<listaFrecProduc.size(); i++){
						frecBean = (FrecTimbradoProducBean)listaFrecProduc.get(i);
						mensajeBean = altaFrecuenciaProdu(frecBean);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
					mensajeBean.setNumero(0);
					mensajeBean.setDescripcion("Frecuencias de Timbrados de Productos agregado Exitosamente.");
					mensajeBean.setNombreControl("frecuenciaID");
					mensajeBean.setConsecutivoInt(mensajeBean.getConsecutivoInt());
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error deFrecuencias de Timbrados de Productos ", e);
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


	public MensajeTransaccionBean bajaFrecuenciaProdu(final FrecTimbradoProducBean  frecTimbradoProducBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
	mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

								String query = "call EDOCTAFRECTIMXPRODBAJ(?,?, ?,?,?,  ?,?,?,?,?, ? );";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setString("Par_FrecuenciaID",frecTimbradoProducBean.getFrecuenciaID());

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
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																											DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));

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
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la baja de Frecuencia de Productos", e);
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

	public MensajeTransaccionBean altaFrecuenciaProdu(final FrecTimbradoProducBean frecTimbradoProducBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
	mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					// Query con el Store Procedure
		mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

								String query = "call EDOCTAFRECTIMXPRODALT(?,?,?,?,?,  ?,?,?,?,?,  ?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setString("Par_FrecuenciaID",frecTimbradoProducBean.getFrecuenciaID());
								sentenciaStore.setInt("Par_ProducCreditoID",Utileria.convierteEntero(frecTimbradoProducBean.getProducCreditoID()));

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
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la alta de Frecuencia de Productos", e);
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


	// LISTA POR FRECUENCIA
		public List listaFrecTimbradoProduc( FrecTimbradoProducBean frecTimbradoProducBean, int tipoLista){
		List listaGrid = null;
		try{

			String query = "call EDOCTAFRECTIMXPRODLIS(?,?,?,?,?, ?,?,?,?,?);";
			Object[] parametros = {
						frecTimbradoProducBean.getFrecuenciaID(),
						Utileria.convierteEntero(frecTimbradoProducBean.getProducCreditoID()),
						tipoLista,

						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						"FrecTimbradoProducDAO.listaFrecTimbradoProduc",
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO
						};


			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call EDOCTAFRECTIMXPRODLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					FrecTimbradoProducBean frecTimbradoProducBean = new FrecTimbradoProducBean();
					frecTimbradoProducBean.setProducCreditoID(resultSet.getString("ProducCreditoID"));
					frecTimbradoProducBean.setDescripcion(resultSet.getString("Descripcion"));


					return frecTimbradoProducBean;
				}
			});
			listaGrid= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Lista de Frecuencias por Productos", e);

			}
			return listaGrid;
		}


		//LISTA PRINCIPAL
		public List listaPrincipal( FrecTimbradoProducBean frecTimbradoProducBean, int tipoLista){
			List listaGrid = null;
		try{

			String query = "call EDOCTAFRECTIMXPRODLIS(?,?,?,?,?, ?,?,?,?,?);";
			Object[] parametros = {
						frecTimbradoProducBean.getFrecuenciaID(),
						Utileria.convierteEntero(frecTimbradoProducBean.getProducCreditoID()),
						tipoLista,

						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						"FrecTimbradoProducDAO.listaFrecTimbradoProduc",
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO
						};


			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call EDOCTAFRECTIMXPRODLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					FrecTimbradoProducBean frecTimbradoProducBean = new FrecTimbradoProducBean();
					frecTimbradoProducBean.setProducCreditoID(resultSet.getString("ProducCreditoID"));
					frecTimbradoProducBean.setDescripcion(resultSet.getString("Descripcion"));


					return frecTimbradoProducBean;
				}
			});
			listaGrid= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Lista de Frecuencias por Productos", e);

		}
		return listaGrid;
		}

		// LISTA FORANEA
		public List listaForanea( FrecTimbradoProducBean frecTimbradoProducBean, int tipoLista){
			List listaGrid = null;
			try{

				String query = "call EDOCTAFRECTIMXPRODLIS(?,?,?,?,?, ?,?,?,?,?);";
				Object[] parametros = {
							frecTimbradoProducBean.getFrecuenciaID(),
							Utileria.convierteEntero(frecTimbradoProducBean.getProducCreditoID()),
							tipoLista,

							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO,
							Constantes.FECHA_VACIA,
							Constantes.STRING_VACIO,
							"FrecTimbradoProducDAO.listaFrecTimbradoProduc",
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO
							};


				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call EDOCTAFRECTIMXPRODLIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						FrecTimbradoProducBean frecTimbradoProducBean = new FrecTimbradoProducBean();
						frecTimbradoProducBean.setProducCreditoID(resultSet.getString("ProducCreditoID"));
						frecTimbradoProducBean.setDescripcion(resultSet.getString("Descripcion"));
						frecTimbradoProducBean.setFrecuenciaID(resultSet.getString("FrecuenciaID"));
						return frecTimbradoProducBean;
					}
				});
				listaGrid= matches;
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Lista de Frecuencias por Productos", e);

			}
			return listaGrid;
		}

		//CONSULTA PRINCIPAL
		public FrecTimbradoProducBean consultaPrincipal(FrecTimbradoProducBean frecTimbradoPro, int tipoConsulta){
			FrecTimbradoProducBean timbradoProducBean = null;
			try{
				String query = "call EDOCTAFRECTIMXPRODCON(" +
						"?,?,?,?,?, ?,?,?,?,?);";
				Object[] parametros = {
						frecTimbradoPro.getFrecuenciaID(),
						Utileria.convierteEntero(frecTimbradoPro.getProducCreditoID()),
						tipoConsulta,

						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						"FrecTimbradoProducDAO.consultaPrincipal",
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO

				};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call EDOCTAFRECTIMXPRODCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						FrecTimbradoProducBean frecTimbradoProduc = new FrecTimbradoProducBean();
						frecTimbradoProduc.setFrecuenciaID(resultSet.getString("FrecuenciaID"));
						frecTimbradoProduc.setProducCreditoID(resultSet.getString("ProducCreditoID"));
						frecTimbradoProduc.setDescripcion(resultSet.getString("Descripcion"));

						return frecTimbradoProduc;
					}
				});
				timbradoProducBean  = matches.size() > 0 ? (FrecTimbradoProducBean) matches.get(0) : null;
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de solicitud de cancelacion", e);
			}
			return timbradoProducBean;
		}
}