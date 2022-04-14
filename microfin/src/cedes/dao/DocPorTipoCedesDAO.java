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

	import cedes.bean.DocPorTipoCedesBean;
	import general.bean.MensajeTransaccionBean;
	import general.dao.BaseDAO;
	import herramientas.Constantes;
	import herramientas.Utileria;


		public class DocPorTipoCedesDAO extends BaseDAO{

					public DocPorTipoCedesDAO() {
					super();
					// TODO Auto-generated constructor stub
				}

				public int mensajeExito=0;
				public int instrumento = 27;

				// metodo de alta de  documentos requeridos por cedes
				public MensajeTransaccionBean altaDocumentosRequeridos(final DocPorTipoCedesBean docPorTipoCedesBean) {
					MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
					mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
						public Object doInTransaction(TransactionStatus transaction) {
							MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
							try {
						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
										new CallableStatementCreator() {
											public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

												String query = "call DOCPORTIPOINSTRUALT(?,?,?,?,?,?,?,?,?,?,?,?,?);";
												CallableStatement sentenciaStore = arg0.prepareCall(query);
												sentenciaStore.setInt("Par_TipoInstrumentoID",27);
												sentenciaStore.setInt("Par_TipoDocCapID",Utileria.convierteEntero(docPorTipoCedesBean.getTipoDocCapID()));
												sentenciaStore.setInt("Par_ProductoID",Utileria.convierteEntero(docPorTipoCedesBean.getTipoProducto()));
												sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

												sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
												sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

												sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
												sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
												sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
												sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
												sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
												sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
												sentenciaStore.setLong("Aud_NumTransaccion",Utileria.convierteLong(docPorTipoCedesBean.getNumTransaccion()));
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
									loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de documentos requeridos", e);
								}
								return mensajeBean;
							}
						});
						return mensaje;
					}



				// metodo de alta de  documentos requeridos por cedes
				public MensajeTransaccionBean grabaDocumentosReqDetalles(final DocPorTipoCedesBean docPorTipoCedesBean, final List listaDetalleDocsReq) {
					MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
					transaccionDAO.generaNumeroTransaccion();

					final long numTransacc = parametrosAuditoriaBean.getNumeroTransaccion();
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
						public Object doInTransaction(TransactionStatus transaction) {
							MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
							MensajeTransaccionBean mensajeBeanBaj = new MensajeTransaccionBean();
							try {
								DocPorTipoCedesBean docPorTipo;
								docPorTipoCedesBean.setNumTransaccion(String.valueOf(numTransacc));

								if(mensajeBean.getNumero()!=0){
									throw new Exception(mensajeBean.getDescripcion());
								}
								mensajeBeanBaj=bajaDocumentosRequeridos(docPorTipoCedesBean);
								if(mensajeBeanBaj.getNumero() == mensajeExito ){
										for(int i=0; i<listaDetalleDocsReq.size(); i++){
											docPorTipo = (DocPorTipoCedesBean)listaDetalleDocsReq.get(i);
											docPorTipo.setTipoProducto(docPorTipoCedesBean.getTipoProducto());
											docPorTipo.setNumTransaccion(docPorTipoCedesBean.getNumTransaccion());
											mensajeBean = altaDocumentosRequeridos(docPorTipo);
											if(mensajeBean.getNumero()!=0){
												throw new Exception(mensajeBean.getDescripcion());
											}
										}
								}else{

									throw new Exception(mensajeBeanBaj.getDescripcion());
								}

								mensajeBean = new MensajeTransaccionBean();
								mensajeBean.setNumero(0);
								mensajeBean.setDescripcion("Los Documentos Requeridos para el Producto: "+docPorTipoCedesBean.getTipoProducto()+" Fueron Agregados Exitosamente.");
								mensajeBean.setNombreControl("tipoProducto");
								mensajeBean.setConsecutivoString(docPorTipoCedesBean.getTipoProducto());
							} catch (Exception e) {
								if(mensajeBean.getNumero()==0){
									mensajeBean.setNumero(999);
								}
								mensajeBean.setDescripcion(e.getMessage());
								transaction.setRollbackOnly();
								e.printStackTrace();
								loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al grabar detalles de documentos requeridos", e);
							}
							return mensajeBean;
						}
					});
					return mensaje;

				}


				// metodo de baja de  documentos requeridos por cedes
				public MensajeTransaccionBean bajaDocumentosRequeridos(final DocPorTipoCedesBean docPorTipoCedesBean) {
					MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
						public Object doInTransaction(TransactionStatus transaction) {
							MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
							try {
				mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
										new CallableStatementCreator() {
											public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

												String query = "call DOCPORTIPOINSTRUBAJ(?,?,?,?,?,?,?,?,?,?,?,?);";
												CallableStatement sentenciaStore = arg0.prepareCall(query);
												sentenciaStore.setInt("Par_ProductoID",Utileria.convierteEntero(docPorTipoCedesBean.getTipoProducto()));
												sentenciaStore.setInt("Par_TipoInstrumentoID",27);
												sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

												sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
												sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

												sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
												sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
												sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
												sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
												sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
												sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
												sentenciaStore.setLong("Aud_NumTransaccion",Utileria.convierteLong(docPorTipoCedesBean.getNumTransaccion()));
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
									loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"baja de documentos requeridos", e);
								}
								return mensajeBean;
							}
						});
						return mensaje;
					}


				// lista de documentos requeridos por cedes
				public List listaDocumentosExistentes(DocPorTipoCedesBean docPorTipoCedesBean, int tipoLista){

					String query = "call DOCPORTIPOINSTRULIS(?,?,?,?,?,?,?,?,?,?,?);";
					Object[] parametros = {

								Utileria.convierteEntero(docPorTipoCedesBean.getTipoProducto()),
								27,
								docPorTipoCedesBean.getDescripcion(),
								tipoLista,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
							};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DOCPORTIPOINSTRULIS(" + Arrays.toString(parametros) + ")");
					List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
							DocPorTipoCedesBean docPorTipoCedesBean = new DocPorTipoCedesBean();
							docPorTipoCedesBean.setTipoDocCapID(resultSet.getString(1));
							docPorTipoCedesBean.setDescripcion(resultSet.getString(2));
							docPorTipoCedesBean.setAsignado(resultSet.getString(3));
							return docPorTipoCedesBean;

						}
					});
					return matches;
					}


			}




