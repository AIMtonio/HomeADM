package fira.dao;

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


import fira.bean.ConceptosInversionAgroBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class ConceptosInversionAgroDAO extends BaseDAO  {

	public ConceptosInversionAgroDAO() {
		super();
	}

	// Guardar elementos del grid
	public MensajeTransaccionBean actualizaListaGrid(final ConceptosInversionAgroBean bean,final List listaDatosGrid) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				MensajeTransaccionBean mensajeBaja = new MensajeTransaccionBean();
				try {
					ConceptosInversionAgroBean conceptosBean;
					  String consecutivo= mensajeBean.getConsecutivoString();

					  mensajeBaja = bajaConceptos(bean);

						if(mensajeBaja.getNumero()==0){

							for(int i=0; i<listaDatosGrid.size(); i++){

								conceptosBean = (ConceptosInversionAgroBean)listaDatosGrid.get(i);

								mensajeBean = altaConceptosInversion(bean,conceptosBean);

								if(mensajeBean.getNumero()!=0){
									throw new Exception(mensajeBean.getDescripcion());
								}
						}
					}else{
						mensajeBean.setNumero(mensajeBaja.getNumero());
						mensajeBean.setDescripcion(mensajeBaja.getDescripcion());
						throw new Exception(mensajeBaja.getDescripcion());
					}

				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al actualizar lista de conceptos de inversion", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	// Guardar elemntos del grid
	public MensajeTransaccionBean bajaElementoGrid(final ConceptosInversionAgroBean bean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = bajaConceptos(bean);

					if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
					}

				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al eliminar lista de conceptos de inversion", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	// Baja conceptos en  grid
	public MensajeTransaccionBean bajaConceptos(final ConceptosInversionAgroBean conceptosBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try{
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CONCEPTOSINVAGROBAJ(?,?,?, ?,?,?, ?,?,?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setLong("Par_SolicitudID", Utileria.convierteLong(conceptosBean.getSolicitudCreditoID()));
								sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(conceptosBean.getClienteID()));
								sentenciaStore.setString("Par_TipoRecurso",conceptosBean.getTipoRecurso());

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
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " error en baja de concepto");
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
						throw new Exception(Constantes.MSG_ERROR + " .ConceptosInver.altaConceptosInversion");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en baja concepto " + e);
					e.printStackTrace();
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

	//baja conceptos Inversion
	public MensajeTransaccionBean altaConceptosInversion(final ConceptosInversionAgroBean conceptosBean,final ConceptosInversionAgroBean listaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try{
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CONCEPTOSINVAGROALT(?,?,?,?, ?,?,?,?,?, ?,?,?, ?,?,?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setLong("Par_SolicitudID", Utileria.convierteLong(conceptosBean.getSolicitudCreditoID()));
								sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(conceptosBean.getClienteID()));
								sentenciaStore.setString("Par_FechaRegistro",Utileria.convierteFecha(conceptosBean.getFechaRegistro()));
								sentenciaStore.setInt("Par_ConceptoInvID",Utileria.convierteEntero(listaBean.getConceptoInvID()));

								sentenciaStore.setDouble("Par_NoUnidad",Utileria.convierteDoble(listaBean.getNoUnidad()));
								sentenciaStore.setString("Par_ClaveUnidad",listaBean.getClaveUnidad());
								sentenciaStore.setString("Par_Unidad",listaBean.getUnidad());
								sentenciaStore.setDouble("Par_Monto",Utileria.convierteDoble(listaBean.getMonto()));
								sentenciaStore.setString("Par_TipoRecurso",listaBean.getTipoRecurso());

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
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " error en alta de concepto");
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
						throw new Exception(Constantes.MSG_ERROR + " .ConceptosInver.altaConceptosInversion");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en alta concepto " + e);
					e.printStackTrace();
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

	// consulta conceptos catalogo
	public ConceptosInversionAgroBean consultaConcepto(ConceptosInversionAgroBean conceptosBean, int tipoConsulta) {
		ConceptosInversionAgroBean conceptosInvBean = null;
		try{
			//Query con el Store Procedure
			String query = "call CATCONCEPTOSINVERAGROCON(?,?,	 ?,?,?,?,?,?,?);";
			Object[] parametros = {	Utileria.convierteEntero(conceptosBean.getConceptoInvID()),
									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"ConceptosInverDAO.consultaConcepto",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
								};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATCONCEPTOSINVERAGROCON(" + Arrays.toString(parametros) + ")");

			List<?> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper<Object>() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ConceptosInversionAgroBean conceptoInv = new ConceptosInversionAgroBean();
					conceptoInv.setConceptoInvID(resultSet.getString("ConceptoFiraID"));
					conceptoInv.setDescripcion(resultSet.getString("Descripcion"));

					return conceptoInv;

				}
			});
			conceptosInvBean= matches.size() > 0 ? (ConceptosInversionAgroBean) matches.get(0) : null;
		}catch(Exception e){
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de conceptos de inversion fira.", e);
			e.printStackTrace();
		}
	return conceptosInvBean;
	}

	// consulta Fecha de Registro
	public ConceptosInversionAgroBean consultaFecha(ConceptosInversionAgroBean conceptosBean, int tipoConsulta) {
		ConceptosInversionAgroBean conceptosInvBean = null;
		try{
			//Query con el Store Procedure
			String query = "call CONCEPTOSINVAGROCON(?,?,?,?,	 ?,?,?,?,?,?,?);";
			Object[] parametros = {	Utileria.convierteLong(conceptosBean.getSolicitudCreditoID()),
									Utileria.convierteEntero(conceptosBean.getClienteID()),
									conceptosBean.getTipoRecurso(),
									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"ConceptosInverDAO.consultaConcepto",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
								};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONCEPTOSINVAGROCON(" + Arrays.toString(parametros) + ")");

			List<?> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper<Object>() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ConceptosInversionAgroBean conceptoInv = new ConceptosInversionAgroBean();
					conceptoInv.setSolicitudCreditoID(resultSet.getString("SolicitudCreditoID"));
					conceptoInv.setClienteID(resultSet.getString("ClienteID"));
					conceptoInv.setFechaRegistro(resultSet.getString("FechaRegistro"));

					return conceptoInv;
				}
			});
			conceptosInvBean= matches.size() > 0 ? (ConceptosInversionAgroBean) matches.get(0) : null;
		}catch(Exception e){
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de conceptos de inversion fira.", e);
			e.printStackTrace();
		}
		return conceptosInvBean;
	}

	// lista grid recursos del prestamo
	public List listaConceptos(ConceptosInversionAgroBean bean, int tipoLista){
		List conceptos = null;
		try{
			//Query con el Store Procedure
			String query = "call CONCEPTOINVERAGROLIS(?,?,?,?, ?,?,?, ?,?,?,?);";

			Object[] parametros = {
									Utileria.convierteLong(bean.getSolicitudCreditoID()),
									Utileria.convierteEntero(bean.getClienteID()),
									bean.getTipoRecurso(),
									tipoLista,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"ConceptosInversionAgroDAO.listaGrid",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONCEPTOINVERAGROLIS(" + Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					ConceptosInversionAgroBean conceptonInvBean = new ConceptosInversionAgroBean();
					conceptonInvBean.setConceptoInvIDRP(resultSet.getString("ConceptoFiraID"));
					conceptonInvBean.setDescripcionRP(resultSet.getString("Descripcion"));
					conceptonInvBean.setNoUnidadRP(resultSet.getString("NoUnidad"));
					conceptonInvBean.setClaveUnidadRP(resultSet.getString("ClaveUnidad"));
					conceptonInvBean.setUnidadRP(resultSet.getString("Unidad"));
					conceptonInvBean.setMontoInversionRP(resultSet.getString("Monto"));
					conceptonInvBean.setTipoRecursoPR(resultSet.getString("TipoRecurso"));
					conceptonInvBean.setTotalPrestamo(resultSet.getString("TotalPrestamo"));
					return conceptonInvBean;
				}
			});
			return conceptos = matches.size() > 0 ? matches: null;

		}catch(Exception e){
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la lista de conceptos de inversion fira.", e);
			e.printStackTrace();
		}
		return conceptos;
	}

	// lista grid recursos del solicitante
	public List listaConceptosSol(ConceptosInversionAgroBean bean, int tipoLista){
		List conceptos = null;
		try{
			//Query con el Store Procedure
			String query = "call CONCEPTOINVERAGROLIS(?,?,?,?, ?,?,?, ?,?,?,?);";

			Object[] parametros = {
									Utileria.convierteLong(bean.getSolicitudCreditoID()),
									Utileria.convierteEntero(bean.getClienteID()),
									bean.getTipoRecurso(),
									tipoLista,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"ConceptosInversionAgroDAO.listaGrid",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONCEPTOINVERAGROLIS(" + Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					ConceptosInversionAgroBean conceptonInvBean = new ConceptosInversionAgroBean();
					conceptonInvBean.setConceptoInvIDRS(resultSet.getString("ConceptoFiraID"));
					conceptonInvBean.setDescripcionRS(resultSet.getString("Descripcion"));
					conceptonInvBean.setNoUnidadRS(resultSet.getString("NoUnidad"));
					conceptonInvBean.setClaveUnidadRS(resultSet.getString("ClaveUnidad"));
					conceptonInvBean.setUnidadRS(resultSet.getString("Unidad"));
					conceptonInvBean.setMontoInversionRS(resultSet.getString("Monto"));
					conceptonInvBean.setTipoRecursoRS(resultSet.getString("TipoRecurso"));
					conceptonInvBean.setTotalSolicitante(resultSet.getString("TotalSolicitante"));
					return conceptonInvBean;
				}
			});
			return conceptos = matches.size() > 0 ? matches: null;

		}catch(Exception e){
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la lista de conceptos de inversion fira.", e);
			e.printStackTrace();
		}
		return conceptos;
	}
	// lista grid recursos de otras Fuentes
		public List listaConceptosOF(ConceptosInversionAgroBean bean, int tipoLista){
			List conceptos = null;
			try{
				//Query con el Store Procedure
				String query = "call CONCEPTOINVERAGROLIS(?,?,?,?, ?,?,?, ?,?,?,?);";

				Object[] parametros = {
										Utileria.convierteLong(bean.getSolicitudCreditoID()),
										Utileria.convierteEntero(bean.getClienteID()),
										bean.getTipoRecurso(),
										tipoLista,

										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO,
										Constantes.FECHA_VACIA,
										Constantes.STRING_VACIO,
										"ConceptosInversionAgroDAO.listaGrid",
										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONCEPTOINVERAGROLIS(" + Arrays.toString(parametros) + ")");

				List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

						ConceptosInversionAgroBean conceptonInvBean = new ConceptosInversionAgroBean();
						conceptonInvBean.setConceptoInvIDROF(resultSet.getString("ConceptoFiraID"));
						conceptonInvBean.setDescripcionOF(resultSet.getString("Descripcion"));
						conceptonInvBean.setNoUnidadOF(resultSet.getString("NoUnidad"));
						conceptonInvBean.setClaveUnidadOF(resultSet.getString("ClaveUnidad"));
						conceptonInvBean.setUnidadOF(resultSet.getString("Unidad"));
						conceptonInvBean.setMontoInversionROF(resultSet.getString("Monto"));
						conceptonInvBean.setTipoRecursoOF(resultSet.getString("TipoRecurso"));
						conceptonInvBean.setTotalotrasFuentes(resultSet.getString("TotalotrasFuentes"));
						return conceptonInvBean;
					}
				});
				return conceptos = matches.size() > 0 ? matches: null;

			}catch(Exception e){
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la lista de conceptos de inversion fira.", e);
				e.printStackTrace();
			}
			return conceptos;
		}

	public List listaCatConceptos(ConceptosInversionAgroBean bean, int tipoLista){
		List conceptos = null;
		try{
			//Query con el Store Procedure
			String query = "call CATCONCEPTOSINVERAGROLIS(?,?,?, ?,?,?, ?,?,?,?);";
			Object[] parametros = {	Utileria.convierteEntero(bean.getConceptoInvID()),
									bean.getDescripcion(),
									tipoLista,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"ConceptosInversionAgroDAO.listaCocncepto",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATCONCEPTOSINVERAGROLIS(" + Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					ConceptosInversionAgroBean conceptonInvBean = new ConceptosInversionAgroBean();
					conceptonInvBean.setConceptoInvID(resultSet.getString("ConceptoFiraID"));
					conceptonInvBean.setDescripcion(resultSet.getString("Descripcion"));
					return conceptonInvBean;
				}
			});
			return conceptos = matches.size() > 0 ? matches: null;

		}catch(Exception e){
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la lista del catalogo de conceptos de inversion fira.", e);
			e.printStackTrace();
		}
		return conceptos;
	}

}
