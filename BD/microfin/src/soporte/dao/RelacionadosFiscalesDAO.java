package soporte.dao;

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
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import soporte.bean.RelacionadosFiscalesBean;

public class RelacionadosFiscalesDAO extends BaseDAO{

	public RelacionadosFiscalesDAO(){
		super();
	}

	/* ALTA DE RELACIONADO FISCAL */
	public MensajeTransaccionBean altaRelacionadoFiscal(final RelacionadosFiscalesBean relacionadosFiscalesBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

								String query = "call RELACIONADOSFISCALESALT(" +
														"?,?,?,?,?, "+
														"?,?,?,?,?, "+
														"?,?,?,?,?, "+
														"?,?,?,?,?, "+
														"?,?,?,?,?, "+
														"?,?,?,?, "+
														"?,?,?, "+			// parametros salida
														"?,?,?,?,?,?,?);"; 	// parametros auditoria

								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(relacionadosFiscalesBean.getClienteID()));
								sentenciaStore.setDouble("Par_ParticipaFiscalCte",Utileria.convierteDoble(relacionadosFiscalesBean.getParticipaFiscalCte()));
								sentenciaStore.setInt("Par_Ejercicio",Utileria.convierteEntero(relacionadosFiscalesBean.getEjercicio()));
								sentenciaStore.setString("Par_TipoRelacionado",relacionadosFiscalesBean.getTipoRelacionado());
								sentenciaStore.setInt("Par_CteRelacionadoID",Utileria.convierteEntero(relacionadosFiscalesBean.getCteRelacionadoID()));

								sentenciaStore.setDouble("Par_ParticipacionFiscal",Utileria.convierteDoble(relacionadosFiscalesBean.getParticipacionFiscal()));
								sentenciaStore.setString("Par_TipoPersona",relacionadosFiscalesBean.getTipoPersona());
								sentenciaStore.setString("Par_PrimerNombre",relacionadosFiscalesBean.getPrimerNombre());
								sentenciaStore.setString("Par_SegundoNombre",relacionadosFiscalesBean.getSegundoNombre());
								sentenciaStore.setString("Par_TercerNombre",relacionadosFiscalesBean.getTercerNombre());

								sentenciaStore.setString("Par_ApellidoPaterno",relacionadosFiscalesBean.getApellidoPaterno());
								sentenciaStore.setString("Par_ApellidoMaterno",relacionadosFiscalesBean.getApellidoMaterno());
								sentenciaStore.setString("Par_RegistroHacienda",relacionadosFiscalesBean.getRegistroHacienda());
								sentenciaStore.setString("Par_Nacion",relacionadosFiscalesBean.getNacion());
								sentenciaStore.setInt("Par_PaisResidencia",Utileria.convierteEntero(relacionadosFiscalesBean.getPaisResidencia()));

								sentenciaStore.setString("Par_RFC",relacionadosFiscalesBean.getRFC());
								sentenciaStore.setString("Par_CURP",relacionadosFiscalesBean.getCURP());
								sentenciaStore.setInt("Par_EstadoID",Utileria.convierteEntero(relacionadosFiscalesBean.getEstadoID()));
								sentenciaStore.setInt("Par_MunicipioID",Utileria.convierteEntero(relacionadosFiscalesBean.getMunicipioID()));
								sentenciaStore.setInt("Par_LocalidadID",Utileria.convierteEntero(relacionadosFiscalesBean.getLocalidadID()));

								sentenciaStore.setInt("Par_ColoniaID",Utileria.convierteEntero(relacionadosFiscalesBean.getColoniaID()));
								sentenciaStore.setString("Par_Calle",relacionadosFiscalesBean.getCalle());
								sentenciaStore.setString("Par_NumeroCasa",relacionadosFiscalesBean.getNumeroCasa());
								sentenciaStore.setString("Par_NumInterior",relacionadosFiscalesBean.getNumInterior());
								sentenciaStore.setString("Par_Piso",relacionadosFiscalesBean.getPiso());

								sentenciaStore.setString("Par_CP",relacionadosFiscalesBean.getCP());
								sentenciaStore.setString("Par_Lote",relacionadosFiscalesBean.getLote());
								sentenciaStore.setString("Par_Manzana",relacionadosFiscalesBean.getManzana());
								sentenciaStore.setString("Par_DireccionCompleta",relacionadosFiscalesBean.getDireccionCompleta());

								//Parametros de Salida
								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
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
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .RelacionadosFiscalesDAO.altaRelacionadoFiscal");
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
						throw new Exception(Constantes.MSG_ERROR + " .RelacionadosFiscalesDAO.altaRelacionadoFiscal");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en alta de relacionado fiscal " + e);
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

	/* BAJA DE RELACIONADOS FISCAL DEL CLIENTE */
	public MensajeTransaccionBean bajaRelacionadosFiscalCte(final RelacionadosFiscalesBean relacionadosFiscalesBean, final int tipoBaja) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

								String query = "call RELACIONADOSFISCALESBAJ(" +
														"?,?, "+
														"?,?,?, "+			// parametros salida
														"?,?,?,?,?,?,?);"; 	// parametros auditoria

								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(relacionadosFiscalesBean.getClienteID()));
								sentenciaStore.setInt("Par_TipoBaja",tipoBaja);

								//Parametros de Salida
								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
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
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .RelacionadosFiscalesDAO.bajaRelacionadosFiscalCte");
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
						throw new Exception(Constantes.MSG_ERROR + " .RelacionadosFiscalesDAO.bajaRelacionadosFiscalCte");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en baja de relacionados fiscal de un cliente " + e);
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

	// Lista de comprobantes por numero de comprobacion de gasto para grid de autorizacion
	public List listaRelacionadosFiscalsGrid(int tipoLista, RelacionadosFiscalesBean bean){
		List listaBean = null;
		try{
			String query = "call RELACIONADOSFISCALESLIS(" +
								"?,?,?, " +
								"?,?,?,?,?,?,?);";// parametros auditoria
			Object[] parametros = {
				Utileria.convierteEntero(bean.getClienteID()),
				Utileria.convierteEntero(bean.getEjercicio()),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"RelacionadosFiscalesDAO.lisRelacionadosFiscalsGrid",
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
			};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call RELACIONADOSFISCALESLIS(  " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {

					RelacionadosFiscalesBean bean = new RelacionadosFiscalesBean();

						bean.setTipoRelacionado(resultSet.getString("TipoRelacionado"));
						bean.setCteRelacionadoID(resultSet.getString("CteRelacionadoID"));
						bean.setParticipacionFiscal(resultSet.getString("ParticipacionFiscal"));
						bean.setTipoPersona(resultSet.getString("TipoPersona"));
						bean.setPrimerNombre(resultSet.getString("PrimerNombre"));

						bean.setSegundoNombre(resultSet.getString("SegundoNombre"));
						bean.setTercerNombre(resultSet.getString("TercerNombre"));
						bean.setApellidoPaterno(resultSet.getString("ApellidoPaterno"));
						bean.setApellidoMaterno(resultSet.getString("ApellidoMaterno"));
						bean.setRegistroHacienda(resultSet.getString("RegistroHacienda"));

						bean.setNacion(resultSet.getString("Nacion"));
						bean.setPaisResidencia(resultSet.getString("PaisResidencia"));
						bean.setRFC(resultSet.getString("RFC"));
						bean.setCURP(resultSet.getString("CURP"));
						bean.setEstadoID(resultSet.getString("EstadoID"));

						bean.setMunicipioID(resultSet.getString("MunicipioID"));
						bean.setLocalidadID(resultSet.getString("LocalidadID"));
						bean.setColoniaID(resultSet.getString("ColoniaID"));
						bean.setCalle(resultSet.getString("Calle"));
						bean.setNumeroCasa(resultSet.getString("NumeroCasa"));

						bean.setNumInterior(resultSet.getString("NumInterior"));
						bean.setPiso(resultSet.getString("Piso"));
						bean.setCP(resultSet.getString("CP"));
						bean.setLote(resultSet.getString("Lote"));
						bean.setManzana(resultSet.getString("Manzana"));

						bean.setDireccionCompleta(resultSet.getString("DireccionCompleta"));

						return bean;
					}
			});

			listaBean = matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de relacionados fiscales", e);
		}
		return listaBean ;
	}

	/* CONSULTA DE LA PARTICIPACION DEL CLIENTE */
	public RelacionadosFiscalesBean conParticipacionCte(int tipoConsulta, RelacionadosFiscalesBean relacionadosFiscalesBean) {
		RelacionadosFiscalesBean bean = null;
		try{
			// Query con el Store Procedure
			String query = "call RELACIONADOSFISCALESCON(" +
					"?,?,?,"+
					"?,?,?,?,?,?,?);";// parametros auditoria

			Object[] parametros = {
				Utileria.convierteEntero(relacionadosFiscalesBean.getClienteID()),
				Utileria.convierteEntero(relacionadosFiscalesBean.getEjercicio()),
				tipoConsulta,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"RelacionadosFiscalesDAO.conParticipacionCte",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
			};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call RELACIONADOSFISCALESCON(  " + Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {

					RelacionadosFiscalesBean beanConsulta = new RelacionadosFiscalesBean();

					beanConsulta.setParticipaFiscalCte(resultSet.getString("ParticipaFiscalCte"));

					return beanConsulta;

				}
			});

			bean= matches.size() > 0 ? (RelacionadosFiscalesBean) matches.get(0) : null;

		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de la participacion del cliente ", e);
		}
		return bean;
	}

	//REPORTE RELACIONADOS FISCALES RETENCION
	public List repRelFiscalRet(final RelacionadosFiscalesBean relacionadosFiscalesBean){
		List listaResultado=null;

		try{
			String query = "CALL RELACIONADOSFISCALESREP(" +
														"?,?,"+
														"?,?,?,?,?,?,?);";// parametros auditoria

			Object[] parametros ={
				Utileria.convierteFecha(relacionadosFiscalesBean.getEjercicio()),
				Utileria.convierteEntero(relacionadosFiscalesBean.getClienteID()),

	    		parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"RelacionadosFiscalesDAO.repRelFiscalRet",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
			};

			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL RELACIONADOSFISCALESREP(  " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					RelacionadosFiscalesBean bean = new RelacionadosFiscalesBean();

					bean.setTipo(resultSet.getString("Tipo"));
					bean.setClienteID(resultSet.getString("Numero"));
					bean.setNombreCompletoCte(resultSet.getString("Nombre"));
					bean.setTipoPersona(resultSet.getString("TipoPersona"));
					bean.setNacion(resultSet.getString("Nacion"));
					bean.setPaisResidencia(resultSet.getString("PaisResidencia"));
					bean.setRegistroHacienda(resultSet.getString("registroHacienda"));
					bean.setRFC(resultSet.getString("RFC"));
					bean.setCURP(resultSet.getString("CURP"));
					bean.setDireccionCompleta(resultSet.getString("DomicilioFiscal"));
					bean.setParticipacionFiscal(resultSet.getString("ParticipacionFiscal"));
					bean.setCapital(resultSet.getString("Capital"));
					bean.setInteresRealPeriodo(resultSet.getString("InteresRealPeriodo"));
					bean.setInteresNominalPeriodo(resultSet.getString("InteresNominalPeriodo"));
					bean.setISRRetenido(resultSet.getString("ISRRetenido"));
					bean.setPerdidaReal(resultSet.getString("PerdidaReal"));


				return bean ;
				}
			});

			listaResultado= matches;

		}catch(Exception e){
			 e.printStackTrace();
			 loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en reporte excel relacionados fiscales. ", e);
		}
		return listaResultado;
	}// fin lista report
}
