package cedes.dao;

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

	import cedes.bean.CheckListCedesBean;


	public class CheckListCedesDAO extends BaseDAO{

		public CheckListCedesDAO() {
			super();
		}

		// Actualiza Lista de documentos
		public MensajeTransaccionBean actualizaListaDocEntregados( final CheckListCedesBean checkListCedesBean, final int tipoTransaccion) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			//transaccionDAO.generaNumeroTransaccion();
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {

						// Query con el Store Procedure
				mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CHEKLISTDOCREQACT(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?, ?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_ProductoID",Utileria.convierteEntero(checkListCedesBean.getCedeID()));
									sentenciaStore.setInt("Par_InstrumentoID",27);
									sentenciaStore.setInt("Par_TipoDocCapID",Utileria.convierteEntero(checkListCedesBean.getClasificaTipDocID()));
									sentenciaStore.setInt("Par_TipoDocumentoID",Utileria.convierteEntero(checkListCedesBean.getTipoDocumentoID()));
									sentenciaStore.setString("Par_DocRecibido",checkListCedesBean.getDocRecibido());
									sentenciaStore.setString("Par_Comentarios",checkListCedesBean.getObservacion());

									sentenciaStore.setInt("Par_TipAct",tipoTransaccion);

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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al actualizar lista de documentos entregados", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}



	   public MensajeTransaccionBean actualizaListaCodigosResp(CheckListCedesBean checkListCedesBean, int tipoTransaccion, final List listaCodigosResp) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

			transaccionDAO.generaNumeroTransaccion();
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						CheckListCedesBean checkListCedesBean;
						  String consecutivo= mensajeBean.getConsecutivoString();
						  int tipoTransaccion=1;
							for(int i=0; i<listaCodigosResp.size(); i++){

								checkListCedesBean = (CheckListCedesBean)listaCodigosResp.get(i);

								mensajeBean = actualizaListaDocEntregados(checkListCedesBean, tipoTransaccion);

								if(mensajeBean.getNumero()!=0){
									throw new Exception(mensajeBean.getDescripcion());
								}
							}

					} catch (Exception e) {
						if(mensajeBean.getNumero()==0){
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al actualizar lista de codigos", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}



			// Lista de Documentos Requeridos CheckList
		public List listaCheckListCedesGrid(CheckListCedesBean checkListCedesBean, int tipoLista){


			String query = "call CHEKLISTDOCREQLIS(?,?,?,?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {
						27,
						Utileria.convierteEntero(checkListCedesBean.getProductoID()),
						Utileria.convierteEntero(checkListCedesBean.getCedeID()),
						Utileria.convierteEntero(checkListCedesBean.getClienteID()),
						Constantes.ENTERO_CERO,
						tipoLista,

						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						Constantes.STRING_VACIO,
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO

						};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CHEKLISTDOCREQLIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CheckListCedesBean checkListCedesBean = new CheckListCedesBean();
					checkListCedesBean.setTipoDocCapID(resultSet.getString(1));
					checkListCedesBean.setDescripcion(resultSet.getString(2));
					checkListCedesBean.setTipoDocumentoID(resultSet.getString(3));
					checkListCedesBean.setDocRecibido(resultSet.getString(4));
					checkListCedesBean.setObservacion(resultSet.getString(5));
					checkListCedesBean.setRecurso(resultSet.getString(6));
					checkListCedesBean.setProcedencia(resultSet.getString(7));
					checkListCedesBean.setArchivoCuentaID(resultSet.getString(8));
					return checkListCedesBean;
				}
			});
			return matches;
		}
		// Lista de tipos de documentos Grid combos
		public List listaCheckListLista(int tipoLista,  CheckListCedesBean checkListCedesBean){
			String query = "call CHEKLISTDOCREQLIS(?,?,?,?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {
					27,
					Utileria.convierteEntero(checkListCedesBean.getProductoID()),
					Utileria.convierteEntero(checkListCedesBean.getTipoCuentaID()),
					Utileria.convierteEntero(checkListCedesBean.getClienteID()),
					Utileria.convierteEntero(checkListCedesBean.getClasificaTipDocID()),
					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					Constantes.STRING_VACIO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
						};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CHEKLISTDOCREQLIS(" + Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CheckListCedesBean checkListCedesBean = new CheckListCedesBean();

					checkListCedesBean.setTipoDocumentoID(resultSet.getString(1));
					checkListCedesBean.setDescripcion(resultSet.getString(2));

					return checkListCedesBean;
				}
			});
			return matches;
		}


		public List ListaDegitalComboDigita(int tipoLista,  CheckListCedesBean checkListCedesBean){
			String query = "call CHEKLISTDOCREQLIS(?,?,?,?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {
					27,
					Utileria.convierteEntero(checkListCedesBean.getTipoCedeID()),
					Utileria.convierteEntero(checkListCedesBean.getCedeID()),
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					Constantes.STRING_VACIO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
						};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CHEKLISTDOCREQLIS(" + Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CheckListCedesBean checkListCedesBean = new CheckListCedesBean();
					checkListCedesBean.setTipoDocumentoID(resultSet.getString(1));
					checkListCedesBean.setDescripcion(resultSet.getString(2));

					return checkListCedesBean;
				}
			});
			return matches;
		}


	}



