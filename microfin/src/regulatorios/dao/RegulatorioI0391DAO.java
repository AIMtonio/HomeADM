package regulatorios.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import regulatorios.bean.RegulatorioI0391Bean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class RegulatorioI0391DAO extends BaseDAO{


	public RegulatorioI0391DAO() {
		super();
	}

	/*
	 * ---------------------------------------------------------------------------------------------------------
	 * ---- SECCION CSV -------------------------------------------------------------------------------------
	 * ---------------------------------------------------------------------------------------------------------
	 */
	/**
	 * Consulta del reporte regulatorio I0391 version CSV
	 * @param bean
	 * @param tipoReporte
	 * @return
	 */
	public List <RegulatorioI0391Bean> reporteRegulatorioI0391Csv(final RegulatorioI0391Bean bean, int tipoReporte){
		transaccionDAO.generaNumeroTransaccion();
		String query = "call `REGULATORIOI0391REP`(?,?,?,?,?,  ?,?,?,?,?);";

		Object[] parametros ={
							Utileria.convierteEntero(bean.getAnio()),
							Utileria.convierteEntero(bean.getMes()),
							tipoReporte,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"RegulatorioI0391DAO.reporteRegulatorioI0391Csv",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOI0391REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				RegulatorioI0391Bean beanResponse= new RegulatorioI0391Bean();
				beanResponse.setRenglon(resultSet.getString("Renglon"));

				return beanResponse ;
			}
		});
		return matches;
	}




	/*
	 * ---------------------------------------------------------------------------------------------------------
	 * ---- SECCION SOCAPS -------------------------------------------------------------------------------------
	 * ---------------------------------------------------------------------------------------------------------
	 */
	// Lista para el grid del Regulatorio I0391
		public List lista( RegulatorioI0391Bean regulatorioI0391Bean, int tipoLista){
		List listaGrid = null;
		try{

			String query = "call REGULATORIOI0391REP(?,?,?,?,?,  ?,?,?,?,?);";
			Object[] parametros = {
						Utileria.convierteEntero(regulatorioI0391Bean.getAnio()),
						Utileria.convierteEntero(regulatorioI0391Bean.getMes()),
						tipoLista,

						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						"RegulatorioI0391DAO.lista",
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO
						};


			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOI0391REP(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					RegulatorioI0391Bean regulatorioI0391Bean = new RegulatorioI0391Bean();

					regulatorioI0391Bean.setAnio(resultSet.getString("Anio"));
					regulatorioI0391Bean.setMes(resultSet.getString("Mes"));
					regulatorioI0391Bean.setClaveEntidad(resultSet.getString("ClaveEntidad"));
					regulatorioI0391Bean.setSubreporte(resultSet.getString("Subreporte"));
					regulatorioI0391Bean.setEntidad(resultSet.getString("Entidad"));
					regulatorioI0391Bean.setEmisora(resultSet.getString("Emisora"));
					regulatorioI0391Bean.setSerie(resultSet.getString("Serie"));
					regulatorioI0391Bean.setFormaAdqui(resultSet.getString("FormaAdqui"));
					regulatorioI0391Bean.setTipoInstru(resultSet.getString("TipoInstru"));
					regulatorioI0391Bean.setClasfConta(resultSet.getString("ClasfConta"));
					regulatorioI0391Bean.setFechaContra(resultSet.getString("FechaContra"));
					regulatorioI0391Bean.setFechaVencim(resultSet.getString("FechaVencim"));
					regulatorioI0391Bean.setNumeroTitu(resultSet.getString("NumeroTitu"));
					regulatorioI0391Bean.setCostoAdqui(resultSet.getString("CostoAdqui"));
					regulatorioI0391Bean.setTasaInteres(resultSet.getString("TasaInteres"));
					regulatorioI0391Bean.setGrupoRiesgo(resultSet.getString("GrupoRiesgo"));
					regulatorioI0391Bean.setValuacion(resultSet.getString("Valuacion"));
					regulatorioI0391Bean.setResValuacion(resultSet.getString("ResValuacion"));


					return regulatorioI0391Bean;
				}
			});
			listaGrid= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Historial del Regulatorio I0391 ", e);

		}
		return listaGrid;
	}

		/*
		 * SOCAP
		 */
		public MensajeTransaccionBean grabaRegulatorioI0391(final RegulatorioI0391Bean regulatorioI0391Bean,final ArrayList listaRegulatorioI0391,final int tipoBaja) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();

			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {

						RegulatorioI0391Bean registroI0391;
						if(listaRegulatorioI0391!=null){
							mensajeBean = bajaRegulatorioI0391(regulatorioI0391Bean, tipoBaja);
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}

						}

						if(listaRegulatorioI0391!=null){
							for(int i=0; i<listaRegulatorioI0391.size(); i++){
								registroI0391 = (RegulatorioI0391Bean)listaRegulatorioI0391.get(i);
								mensajeBean = altaRegulatorioI0391(registroI0391,regulatorioI0391Bean);
								if(mensajeBean.getNumero()!=0){
									throw new Exception(mensajeBean.getDescripcion());
								}
							}
						}

						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(0);
						mensajeBean.setDescripcion("Operación Realizada Exitosamente");
						mensajeBean.setNombreControl("producCreditoID");
						mensajeBean.setConsecutivoInt(Constantes.STRING_CERO);
					} catch (Exception e) {
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al registrar Regulatorio I0391", e);
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


		public MensajeTransaccionBean bajaRegulatorioI0391(final RegulatorioI0391Bean regulatorioI0391Bean,final int tipoBja) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {

						// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call `REGULATORIOI0391BAJ`(?,?,?,?,?,   ?,?,?,?,?,  ?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_Anio",Utileria.convierteEntero(regulatorioI0391Bean.getAnio()));
									sentenciaStore.setInt("Par_Mes",Utileria.convierteEntero(regulatorioI0391Bean.getMes()));
									sentenciaStore.setInt("Par_TipoBaja",tipoBja);
									sentenciaStore.setInt("Par_TipoInstitucion", Utileria.convierteEntero(regulatorioI0391Bean.getInstitucionID()));

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID","RegulatorioI0391DAO.bajaRegulatorioI0391");
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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de Historial Regulatorio I0391", e);
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

		public MensajeTransaccionBean altaRegulatorioI0391(final RegulatorioI0391Bean regulatorioI0391Bean,final RegulatorioI0391Bean regulatorioI0391) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {

						// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call `REGI039100006ALT`(?,?,?,?,?,   ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,  ?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_Anio",Utileria.convierteEntero(regulatorioI0391Bean.getAnio()));
									sentenciaStore.setInt("Par_Mes",Utileria.convierteEntero(regulatorioI0391Bean.getMes()));
									sentenciaStore.setString("Par_Entidad",regulatorioI0391Bean.getEntidad());
									sentenciaStore.setString("Par_Emisora",regulatorioI0391Bean.getEmisora());
									sentenciaStore.setString("Par_Serie",regulatorioI0391Bean.getSerie());

									sentenciaStore.setString("Par_FormaAdqui",regulatorioI0391Bean.getFormaAdqui());
									sentenciaStore.setString("Par_TipoInstru",regulatorioI0391Bean.getTipoInstru());
									sentenciaStore.setString("Par_ClasfConta",regulatorioI0391Bean.getClasfConta());
									sentenciaStore.setString("Par_FechaContra",regulatorioI0391Bean.getFechaContra());
									sentenciaStore.setString("Par_FechaVencim",regulatorioI0391Bean.getFechaVencim());

									sentenciaStore.setString("Par_NumeroTitu",regulatorioI0391Bean.getNumeroTitu());
									sentenciaStore.setString("Par_CostoAdqui",regulatorioI0391Bean.getCostoAdqui());
									sentenciaStore.setString("Par_TasaInteres",regulatorioI0391Bean.getTasaInteres());
									sentenciaStore.setString("Par_GrupoRiesgo",regulatorioI0391Bean.getGrupoRiesgo());
									sentenciaStore.setString("Par_Valuacion",regulatorioI0391Bean.getValuacion());

									sentenciaStore.setString("Par_ResValuacion",regulatorioI0391Bean.getResValuacion());
									sentenciaStore.setInt("Par_TipoInstitucion", Utileria.convierteEntero(regulatorioI0391Bean.getInstitucionID()));
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.setInt("Aud_Empresa",parametrosAuditoriaBean.getEmpresaID());

									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID","RegulatorioI0391DAO.altaRegulatorioI0391");
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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de Historial Regulatorio I0391", e);
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



		/**
		 * Consulta para generar el reporte en Excel regulatorio I0391
		 * @param bean
		 * @param tipoReporte
		 * @return
		 */
		public List <RegulatorioI0391Bean> reporteRegulatorioI0391Socap(final RegulatorioI0391Bean bean, int tipoReporte){
			transaccionDAO.generaNumeroTransaccion();
			String query = "call `REGULATORIOI0391REP`(?,?,?,?,?,  ?,?,?,?,?);";

			Object[] parametros ={
								Utileria.convierteEntero(bean.getAnio()),
								Utileria.convierteEntero(bean.getMes()),
								tipoReporte,
					    		parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"RegulatorioI0391DAO.reporteRegulatorioI0391Socap",
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOI0391REP(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					RegulatorioI0391Bean beanResponse= new RegulatorioI0391Bean();

					beanResponse.setPeriodo(resultSet.getString("Periodo"));
					beanResponse.setClaveEntidad(resultSet.getString("ClaveEntidad"));
					beanResponse.setSubreporte(resultSet.getString("Subreporte"));
					beanResponse.setEntidad(resultSet.getString("Entidad"));
					beanResponse.setSerie(resultSet.getString("Serie"));

					beanResponse.setFormaAdqui(resultSet.getString("FormaAdqui"));
					beanResponse.setTipoInstru(resultSet.getString("TipoInstru"));
					beanResponse.setClasfConta(resultSet.getString("ClasfConta"));
					beanResponse.setFechaContra(resultSet.getString("FechaContra"));
					beanResponse.setEmisora(resultSet.getString("Emisora"));

					beanResponse.setFechaVencim(resultSet.getString("FechaVencim"));
					beanResponse.setNumeroTitu(resultSet.getString("NumeroTitu"));
					beanResponse.setCostoAdqui(resultSet.getString("CostoAdqui"));
					beanResponse.setTasaInteres(resultSet.getString("TasaInteres"));
					beanResponse.setGrupoRiesgo(resultSet.getString("GrupoRiesgo"));

					beanResponse.setValuacion(resultSet.getString("Valuacion"));
					beanResponse.setResValuacion(resultSet.getString("ResValuacion"));



					return beanResponse ;
				}
			});
			return matches;
		}





		/*
		 * ---------------------------------------------------------------------------------------------------------
		 * ---- SECCION SOFIPO -------------------------------------------------------------------------------------
		 * ---------------------------------------------------------------------------------------------------------
		 */
		// Lista para el grid del Regulatorio I0391
			public List listaSofipo( RegulatorioI0391Bean regulatorioI0391Bean, int tipoLista){
			List listaGrid = null;
			try{

				String query = "call REGULATORIOI0391REP(?,?,?,?,?,  ?,?,?,?,?);";
				Object[] parametros = {
							Utileria.convierteEntero(regulatorioI0391Bean.getAnio()),
							Utileria.convierteEntero(regulatorioI0391Bean.getMes()),
							tipoLista,

							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO,
							Constantes.FECHA_VACIA,
							Constantes.STRING_VACIO,
							"RegulatorioI0391DAO.listaSofipo",
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO
							};


				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOI0391REP(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						RegulatorioI0391Bean regulatorioI0391Bean = new RegulatorioI0391Bean();

						regulatorioI0391Bean.setAnio(resultSet.getString("Anio"));
						regulatorioI0391Bean.setMes(resultSet.getString("Mes"));
						regulatorioI0391Bean.setClaveEntidad(resultSet.getString("ClaveEntidad"));
						regulatorioI0391Bean.setSubreporte(resultSet.getString("Subreporte"));
						regulatorioI0391Bean.setEntidad(resultSet.getString("Entidad"));
						regulatorioI0391Bean.setTipoValorID(resultSet.getString("TipoValorID"));
						regulatorioI0391Bean.setEmisora(resultSet.getString("Emisora"));
						regulatorioI0391Bean.setSerie(resultSet.getString("Serie"));
						regulatorioI0391Bean.setFormaAdqui(resultSet.getString("FormaAdqui"));
						regulatorioI0391Bean.setTipoInversion(resultSet.getString("TipoInversion"));
						regulatorioI0391Bean.setTipoInstru(resultSet.getString("TipoInstru"));
						regulatorioI0391Bean.setClasfConta(resultSet.getString("ClasfConta"));
						regulatorioI0391Bean.setFechaContra(resultSet.getString("FechaContra"));
						regulatorioI0391Bean.setFechaVencim(resultSet.getString("FechaVencim"));
						regulatorioI0391Bean.setNumeroTitu(resultSet.getString("NumeroTitu"));
						regulatorioI0391Bean.setCostoAdqui(resultSet.getString("CostoAdqui"));
						regulatorioI0391Bean.setTasaInteres(resultSet.getString("TasaInteres"));
						regulatorioI0391Bean.setGrupoRiesgo(resultSet.getString("GrupoRiesgo"));
						regulatorioI0391Bean.setValuacion(resultSet.getString("Valuacion"));
						regulatorioI0391Bean.setResValuacion(resultSet.getString("ResValuacion"));


						return regulatorioI0391Bean;
					}
				});
				listaGrid= matches;
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Historial del Regulatorio I0391 ", e);

			}
			return listaGrid;
		}


			public MensajeTransaccionBean grabaRegulatorioI0391Sofipo(final RegulatorioI0391Bean regulatorioI0391Bean,final ArrayList listaRegulatorioI0391,final int tipoBaja) {
				MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
				transaccionDAO.generaNumeroTransaccion();

				mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						try {

							RegulatorioI0391Bean registroI0391;
							if(listaRegulatorioI0391!=null){
								mensajeBean = bajaRegulatorioI0391(regulatorioI0391Bean, tipoBaja);
								if(mensajeBean.getNumero()!=0){
									throw new Exception(mensajeBean.getDescripcion());
								}

							}

							if(listaRegulatorioI0391!=null){
								for(int i=0; i<listaRegulatorioI0391.size(); i++){
									registroI0391 = (RegulatorioI0391Bean)listaRegulatorioI0391.get(i);
									mensajeBean = altaRegulatorioI0391Sofipo(registroI0391,regulatorioI0391Bean);
									if(mensajeBean.getNumero()!=0){
										throw new Exception(mensajeBean.getDescripcion());
									}
								}
							}

							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(0);
							mensajeBean.setDescripcion("Operación Realizada Exitosamente");
							mensajeBean.setNombreControl("producCreditoID");
							mensajeBean.setConsecutivoInt(Constantes.STRING_CERO);
						} catch (Exception e) {
							e.printStackTrace();
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al registrar Regulatorio I0391", e);
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



			public MensajeTransaccionBean altaRegulatorioI0391Sofipo(final RegulatorioI0391Bean regulatorioI0391Bean,final RegulatorioI0391Bean regulatorioI0391) {
				MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						try {

							// Query con el Store Procedure
				mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
								new CallableStatementCreator() {
									public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
										String query = "call `REGI039100003ALT`(?,?,?,?,?,   ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?);";
										CallableStatement sentenciaStore = arg0.prepareCall(query);

										sentenciaStore.setInt("Par_Anio",Utileria.convierteEntero(regulatorioI0391Bean.getAnio()));
										sentenciaStore.setInt("Par_Mes",Utileria.convierteEntero(regulatorioI0391Bean.getMes()));
										sentenciaStore.setString("Par_Entidad",regulatorioI0391Bean.getEntidad());
										sentenciaStore.setString("Par_TipoValorID", regulatorioI0391Bean.getTipoValorID());
										sentenciaStore.setString("Par_Emisora",regulatorioI0391Bean.getEmisora());

										sentenciaStore.setString("Par_Serie",regulatorioI0391Bean.getSerie());
										sentenciaStore.setString("Par_FormaAdqui",regulatorioI0391Bean.getFormaAdqui());
										sentenciaStore.setString("Par_TipoInversion", regulatorioI0391Bean.getTipoInversion());
										sentenciaStore.setString("Par_TipoInstru",regulatorioI0391Bean.getTipoInstru());
										sentenciaStore.setString("Par_ClasfConta",regulatorioI0391Bean.getClasfConta());

										sentenciaStore.setString("Par_FechaContra",regulatorioI0391Bean.getFechaContra());
										sentenciaStore.setString("Par_FechaVencim",regulatorioI0391Bean.getFechaVencim());
										sentenciaStore.setString("Par_NumeroTitu",regulatorioI0391Bean.getNumeroTitu());
										sentenciaStore.setString("Par_CostoAdqui",regulatorioI0391Bean.getCostoAdqui());
										sentenciaStore.setString("Par_TasaInteres",regulatorioI0391Bean.getTasaInteres());

										sentenciaStore.setString("Par_GrupoRiesgo",regulatorioI0391Bean.getGrupoRiesgo());
										sentenciaStore.setString("Par_Valuacion",regulatorioI0391Bean.getValuacion());
										sentenciaStore.setInt("Par_TipoInstitucion", Utileria.convierteEntero(regulatorioI0391Bean.getInstitucionID()));
										sentenciaStore.setString("Par_ResValuacion",regulatorioI0391Bean.getResValuacion());
										sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

										sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
										sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
										sentenciaStore.setInt("Aud_Empresa",parametrosAuditoriaBean.getEmpresaID());
										sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
										sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());

										sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
										sentenciaStore.setString("Aud_ProgramaID","RegulatorioI0391DAO.altaRegulatorioI0391Sofipo");
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
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de Historial Regulatorio I0391", e);
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



			/**
			 * Consulta para generar el reporte en Excel regulatorio I0391
			 * @param bean
			 * @param tipoReporte
			 * @return
			 */
			public List <RegulatorioI0391Bean> reporteRegulatorioI0391Sofipo(final RegulatorioI0391Bean bean, int tipoReporte){
				transaccionDAO.generaNumeroTransaccion();
				String query = "call REGULATORIOI0391REP(?,?,?,?,?,  ?,?,?,?,?);";

				Object[] parametros ={
									Utileria.convierteEntero(bean.getAnio()),
									Utileria.convierteEntero(bean.getMes()),
									tipoReporte,
						    		parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"RegulatorioI0391DAO.reporteRegulatorioI0391Sofipo",
									parametrosAuditoriaBean.getSucursal(),
									parametrosAuditoriaBean.getNumeroTransaccion()
				};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOI0391REP(" + Arrays.toString(parametros) +")");
				List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

						RegulatorioI0391Bean beanResponse= new RegulatorioI0391Bean();

						beanResponse.setPeriodo(resultSet.getString("Periodo"));
						beanResponse.setClaveEntidad(resultSet.getString("ClaveEntidad"));
						beanResponse.setSubreporte(resultSet.getString("Subreporte"));
						beanResponse.setEntidad(resultSet.getString("Entidad"));
						beanResponse.setTipoValorID(resultSet.getString("TipoValor"));
						beanResponse.setSerie(resultSet.getString("Serie"));

						beanResponse.setFormaAdqui(resultSet.getString("FormaAdqui"));
						beanResponse.setTipoInversion(resultSet.getString("TipoInversion"));
						beanResponse.setTipoInstru(resultSet.getString("TipoInstru"));

						beanResponse.setClasfConta(resultSet.getString("ClasfConta"));
						beanResponse.setFechaContra(resultSet.getString("FechaContra"));
						beanResponse.setEmisora(resultSet.getString("Emisora"));

						beanResponse.setFechaVencim(resultSet.getString("FechaVencim"));
						beanResponse.setNumeroTitu(resultSet.getString("NumeroTitu"));
						beanResponse.setCostoAdqui(resultSet.getString("CostoAdqui"));
						beanResponse.setTasaInteres(resultSet.getString("TasaInteres"));
						beanResponse.setGrupoRiesgo(resultSet.getString("GrupoRiesgo"));

						beanResponse.setValuacion(resultSet.getString("Valuacion"));
						beanResponse.setResValuacion(resultSet.getString("ResValuacion"));



						return beanResponse ;
					}
				});
				return matches;
			}






}
