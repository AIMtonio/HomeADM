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
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import regulatorios.bean.RegulatorioA1713Bean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class RegulatorioA1713DAO extends BaseDAO{


	public RegulatorioA1713DAO() {
		super();
	}

	// Lista para el grid del Regulatorio A1713
		public List lista( RegulatorioA1713Bean regulatorioA1713Bean, int tipoLista){
		List listaGrid = null;
		try{

			String query = "call `HIS-REGULATORIOA1713LIS`(?,?,?,?,?,  ?,?,?,?);";
			Object[] parametros = {
						Utileria.convierteFecha(regulatorioA1713Bean.getFecha()),
						tipoLista,

						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						"RegulatorioA1713DAO.lista",
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO
						};


			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call `HIS-REGULATORIOA1713LIS`(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					RegulatorioA1713Bean regulatorioA1713Bean = new RegulatorioA1713Bean();

					regulatorioA1713Bean.setFecha(resultSet.getString("Fecha"));
					regulatorioA1713Bean.setClaveEntidad(resultSet.getString("ClaveEntidad"));
					regulatorioA1713Bean.setSubreporte(resultSet.getString("Subreporte"));
					regulatorioA1713Bean.setTipoMovimiento(resultSet.getString("TipoMovimiento"));
					regulatorioA1713Bean.setNombreFuncionario(resultSet.getString("NombreFuncionario"));
					regulatorioA1713Bean.setRfc(resultSet.getString("RFC"));
					regulatorioA1713Bean.setCurp(resultSet.getString("CURP"));
					regulatorioA1713Bean.setProfesion(resultSet.getString("Profesion"));
					regulatorioA1713Bean.setCalleDomicilio(resultSet.getString("CalleDomicilio"));
					regulatorioA1713Bean.setNumeroExt(resultSet.getString("NumeroExt"));
					regulatorioA1713Bean.setNumeroInt(resultSet.getString("NumeroInt"));
					regulatorioA1713Bean.setColoniaDomicilio(resultSet.getString("ColoniaDomicilio"));
					regulatorioA1713Bean.setCodigoPostal(resultSet.getString("CodigoPostal"));
					regulatorioA1713Bean.setLocalidad(resultSet.getString("Localidad"));
					regulatorioA1713Bean.setEstado(resultSet.getString("Estado"));
					regulatorioA1713Bean.setPais(resultSet.getString("Pais"));
					regulatorioA1713Bean.setTelefono(resultSet.getString("Telefono"));
					regulatorioA1713Bean.setEmail(resultSet.getString("Email"));
					regulatorioA1713Bean.setFechaMovimiento(resultSet.getString("FechaMovimiento"));
					regulatorioA1713Bean.setFechaInicio(resultSet.getString("FechaInicio"));
					regulatorioA1713Bean.setOrganoPerteneciente(resultSet.getString("OrganoPerteneciente"));
					regulatorioA1713Bean.setCargo(resultSet.getString("Cargo"));
					regulatorioA1713Bean.setPermanente(resultSet.getString("Permanente"));
					regulatorioA1713Bean.setManifestCumplimiento(resultSet.getString("ManifestCumplimiento"));
					regulatorioA1713Bean.setMunicipio(resultSet.getString("Municipio"));



					return regulatorioA1713Bean;
				}
			});
			listaGrid= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Historial del Regulatorio A1713 ", e);

		}
		return listaGrid;
	}


		public MensajeTransaccionBean grabaRegulatorioA1713(final RegulatorioA1713Bean regulatorioA1713Bean,final ArrayList listaRegulatorioA1713) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();

			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {

						RegulatorioA1713Bean registroA1713;
						if(listaRegulatorioA1713!=null){
							mensajeBean = bajaRegulatorioA1713(regulatorioA1713Bean);
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}

						}

						if(listaRegulatorioA1713!=null){
							for(int i=0; i<listaRegulatorioA1713.size(); i++){
								registroA1713 = (RegulatorioA1713Bean)listaRegulatorioA1713.get(i);
								mensajeBean = altaRegulatorioA1713(registroA1713,regulatorioA1713Bean);
								if(mensajeBean.getNumero()!=0){
									throw new Exception(mensajeBean.getDescripcion());
								}
							}
						}

						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(0);
						mensajeBean.setDescripcion("Operación Realizada Exitosamente");
						mensajeBean.setNombreControl("regulatorioA1713ID");
						mensajeBean.setConsecutivoInt(Constantes.STRING_CERO);
					} catch (Exception e) {
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al registrar Regulatorio A1713", e);
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


		public MensajeTransaccionBean bajaRegulatorioA1713(final RegulatorioA1713Bean regulatorioA1713Bean) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {

						// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call `HIS-REGULATORIOA1713BAJ`(?,?,?,?,?,   ?,?,?,?,?,  ?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setString("Par_Fecha",(regulatorioA1713Bean.getFecha()));



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
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de Historial Regulatorio A1713", e);
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

		public MensajeTransaccionBean altaRegulatorioA1713(final RegulatorioA1713Bean regulatorioA1713Bean,final RegulatorioA1713Bean regulatorioA1713) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {

						// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call `HIS-REGULATORIOA1713ALT`(?,?,?,?,?,   ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_Fecha",regulatorioA1713Bean.getFecha());

									sentenciaStore.setString("Par_TipoMovimiento",regulatorioA1713Bean.getTipoMovimiento());
									sentenciaStore.setString("Par_NombreFuncionario",regulatorioA1713Bean.getNombreFuncionario());
									sentenciaStore.setString("Par_RFC",regulatorioA1713Bean.getRfc());
									sentenciaStore.setString("Par_CURP",regulatorioA1713Bean.getCurp());

									sentenciaStore.setInt("Par_Profesion",(Utileria.convierteEntero(regulatorioA1713Bean.getProfesion())));
									sentenciaStore.setString("Par_CalleDomicilio",regulatorioA1713Bean.getCalleDomicilio());
									sentenciaStore.setString("Par_NumeroExt",regulatorioA1713Bean.getNumeroExt());
									sentenciaStore.setString("Par_NumeroInt",regulatorioA1713Bean.getNumeroInt());
									sentenciaStore.setString("Par_ColoniaDomicilio",regulatorioA1713Bean.getColoniaDomicilio());

									sentenciaStore.setString("Par_CodigoPostal",regulatorioA1713Bean.getCodigoPostal());
									sentenciaStore.setString("Par_Localidad",regulatorioA1713Bean.getLocalidad());
									sentenciaStore.setInt("Par_Estado",Utileria.convierteEntero(regulatorioA1713Bean.getEstado()));
									sentenciaStore.setInt("Par_Pais",Utileria.convierteEntero(regulatorioA1713Bean.getPais()));
									sentenciaStore.setString("Par_Telefono",regulatorioA1713Bean.getTelefono());

									sentenciaStore.setString("Par_Email",regulatorioA1713Bean.getEmail());
									sentenciaStore.setString("Par_FechaMovimiento",Utileria.convierteFecha(regulatorioA1713Bean.getFechaMovimiento()));
									sentenciaStore.setString("Par_FechaInicio",Utileria.convierteFecha(regulatorioA1713Bean.getFechaInicio()));
									sentenciaStore.setInt("Par_OrganoPerteneciente",Utileria.convierteEntero(regulatorioA1713Bean.getOrganoPerteneciente()));
									sentenciaStore.setInt("Par_Cargo",Utileria.convierteEntero(regulatorioA1713Bean.getCargo()));

									sentenciaStore.setInt("Par_Permanente",Utileria.convierteEntero(regulatorioA1713Bean.getPermanente()));
									sentenciaStore.setInt("Par_ManifestCumplimiento",Utileria.convierteEntero(regulatorioA1713Bean.getManifestCumplimiento()));
									sentenciaStore.setInt("Par_Municipio",Utileria.convierteEntero(regulatorioA1713Bean.getMunicipio()));

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Aud_Empresa",parametrosAuditoriaBean.getEmpresaID());
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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de Historial Regulatorio A1713", e);
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
		 * Consulta para generar el reporte en Excel regulatorio A1713
		 * @param bean
		 * @param tipoReporte
		 * @return
		 */
		public List <RegulatorioA1713Bean> reporteRegulatorioA1713(final RegulatorioA1713Bean bean, int tipoReporte){
			transaccionDAO.generaNumeroTransaccion();
			String query = "call `HIS-REGULATORIOA1713LIS`(?,?,?,?,?,  ?,?,?,?);";

			Object[] parametros ={
								bean.getFecha(),
								tipoReporte,
					    		parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call HIS-REGULATORIOA1713LIS(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					RegulatorioA1713Bean beanResponse= new RegulatorioA1713Bean();



					beanResponse.setFecha(resultSet.getString("Fecha"));
					beanResponse.setClaveEntidad(resultSet.getString("ClaveEntidad"));
					beanResponse.setSubreporte(resultSet.getString("Subreporte"));
					beanResponse.setTipoMovimiento(resultSet.getString("TipoMovimiento"));
					beanResponse.setNombreFuncionario(resultSet.getString("NombreFuncionario"));

					beanResponse.setRfc(resultSet.getString("RFC"));
					beanResponse.setCurp(resultSet.getString("CURP"));
					beanResponse.setProfesion(resultSet.getString("Profesion"));
					beanResponse.setCalleDomicilio(resultSet.getString("CalleDomicilio"));
					beanResponse.setNumeroExt(resultSet.getString("NumeroExt"));

					beanResponse.setNumeroInt(resultSet.getString("NumeroInt"));
					beanResponse.setColoniaDomicilio(resultSet.getString("ColoniaDomicilio"));
					beanResponse.setCodigoPostal(resultSet.getString("CodigoPostal"));
					beanResponse.setLocalidad(resultSet.getString("Localidad"));
					beanResponse.setEstado(resultSet.getString("Estado"));

					beanResponse.setPais(resultSet.getString("Pais"));
					beanResponse.setTelefono(resultSet.getString("Telefono"));
					beanResponse.setEmail(resultSet.getString("Email"));
					beanResponse.setFechaMovimiento(resultSet.getString("FechaMovimiento"));
					beanResponse.setFechaInicio(resultSet.getString("FechaInicio"));

					beanResponse.setOrganoPerteneciente(resultSet.getString("OrganoPerteneciente"));
					beanResponse.setCargo(resultSet.getString("Cargo"));
					beanResponse.setPermanente(resultSet.getString("Permanente"));
					beanResponse.setManifestCumplimiento(resultSet.getString("ManifestCumplimiento"));
					beanResponse.setAsentamiento(resultSet.getString("Asentamiento"));
					beanResponse.setNombrePais(resultSet.getString("NombrePais"));
					beanResponse.setNombreEstado(resultSet.getString("NombreEstado"));
					beanResponse.setNombreLocalidad(resultSet.getString("NombreLocalidad"));


					return beanResponse ;
				}
			});
			return matches;
		}
		/**
		 * Consulta del reporte regulatorio A1713 version CSV
		 * @param bean
		 * @param tipoReporte
		 * @return
		 */
		public List <RegulatorioA1713Bean> reporteRegulatorioA1713Csv(final RegulatorioA1713Bean bean, int tipoReporte){
			transaccionDAO.generaNumeroTransaccion();
			String query = "call `HIS-REGULATORIOA1713LIS`(?,?,?,?,?,  ?,?,?,?);";

			Object[] parametros ={
								bean.getFecha(),
								tipoReporte,
					    		parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call HIS-REGULATORIOA1713LIS(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					RegulatorioA1713Bean beanResponse= new RegulatorioA1713Bean();
					beanResponse.setRenglon(resultSet.getString("Renglon"));

					return beanResponse ;
				}
			});
			return matches;
		}





		public MensajeTransaccionBean altaRegistroRegA1713Sofipo(final RegulatorioA1713Bean regulatorioA1713Bean) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				@SuppressWarnings("unchecked")
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {

						// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call REGISTROREGA1713ALT(?,?,?,?,?,   ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setString("Par_Fecha",regulatorioA1713Bean.getFecha());
								    sentenciaStore.setInt("Par_TipoMovimientoID",Utileria.convierteEntero(regulatorioA1713Bean.getTipoMovimientoID()));
								    sentenciaStore.setString("Par_NombreFuncionario",regulatorioA1713Bean.getNombreFuncionario());
								    sentenciaStore.setString("Par_RFC",regulatorioA1713Bean.getRfcFuncionario());

								    sentenciaStore.setString("Par_CURP",regulatorioA1713Bean.getCurpFuncionario());
								    sentenciaStore.setInt("Par_Profesion",Utileria.convierteEntero(regulatorioA1713Bean.getTituloPofID()));
								    sentenciaStore.setString("Par_Telefono",regulatorioA1713Bean.getTelefono());
								    sentenciaStore.setString("Par_Email",regulatorioA1713Bean.getCorreoElectronico());
								    sentenciaStore.setInt("Par_PaisID",Utileria.convierteEntero(regulatorioA1713Bean.getPaisID()));

								    sentenciaStore.setInt("Par_EstadoID",Utileria.convierteEntero(regulatorioA1713Bean.getEstadoID()));
								    sentenciaStore.setInt("Par_MunicipioID",Utileria.convierteEntero(regulatorioA1713Bean.getMunicipioID()));
								    sentenciaStore.setString("Par_LocalidadID",regulatorioA1713Bean.getLocalidadID());
								    sentenciaStore.setInt("Par_ColoniaID",Utileria.convierteEntero(regulatorioA1713Bean.getColoniaID()));
								    sentenciaStore.setString("Par_CodigoPostal",regulatorioA1713Bean.getCodigoPostal());

								    sentenciaStore.setString("Par_Calle",regulatorioA1713Bean.getCalle());
								    sentenciaStore.setString("Par_NumeroExt",regulatorioA1713Bean.getNumeroExt());
								    sentenciaStore.setString("Par_NumeroInt",regulatorioA1713Bean.getNumeroInt());
								    sentenciaStore.setString("Par_FechaMovimiento",regulatorioA1713Bean.getFechaMovimiento());
								    sentenciaStore.setString("Par_FechaInicioGes",regulatorioA1713Bean.getInicioGestion());

								    sentenciaStore.setString("Par_FechaFinGestion",regulatorioA1713Bean.getConclusionGestion());
								    sentenciaStore.setInt("Par_OrganoID",Utileria.convierteEntero(regulatorioA1713Bean.getOrganoID()));
								    sentenciaStore.setInt("Par_CargoID",Utileria.convierteEntero(regulatorioA1713Bean.getCargoID()));
								    sentenciaStore.setInt("Par_PermanenteID",Utileria.convierteEntero(regulatorioA1713Bean.getPermanenteSupID()));
								    sentenciaStore.setInt("Par_CausaBajaID",Utileria.convierteEntero(regulatorioA1713Bean.getCausaBajaID()));

								    sentenciaStore.setInt("Par_ManifestCumpID",Utileria.convierteEntero(regulatorioA1713Bean.getManifestacionID()));

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
										mensajeTransaccion.setNumero(Utileria.convierteEntero((resultadosStore.getString("NumErr"))));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));

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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de Registro de Regulatorio A1713", e);
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



		public MensajeTransaccionBean modificaRegistroRegA1713Sofipo(final RegulatorioA1713Bean regulatorioA1713Bean) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				@SuppressWarnings("unchecked")
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {

						// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call REGISTROREGA1713MOD(?,?,?,?,?,   ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setString("Par_Fecha",regulatorioA1713Bean.getFecha());
								    sentenciaStore.setInt("Par_RegistroID",Utileria.convierteEntero(regulatorioA1713Bean.getRegistroID()));
								    sentenciaStore.setInt("Par_TipoMovimientoID",Utileria.convierteEntero(regulatorioA1713Bean.getTipoMovimientoID()));
								    sentenciaStore.setString("Par_NombreFuncionario",regulatorioA1713Bean.getNombreFuncionario());
								    sentenciaStore.setString("Par_RFC",regulatorioA1713Bean.getRfcFuncionario());

								    sentenciaStore.setString("Par_CURP",regulatorioA1713Bean.getCurpFuncionario());
								    sentenciaStore.setInt("Par_Profesion",Utileria.convierteEntero(regulatorioA1713Bean.getTituloPofID()));
								    sentenciaStore.setString("Par_Telefono",regulatorioA1713Bean.getTelefono());
								    sentenciaStore.setString("Par_Email",regulatorioA1713Bean.getCorreoElectronico());
								    sentenciaStore.setInt("Par_PaisID",Utileria.convierteEntero(regulatorioA1713Bean.getPaisID()));

								    sentenciaStore.setInt("Par_EstadoID",Utileria.convierteEntero(regulatorioA1713Bean.getEstadoID()));
								    sentenciaStore.setInt("Par_MunicipioID",Utileria.convierteEntero(regulatorioA1713Bean.getMunicipioID()));
								    sentenciaStore.setString("Par_LocalidadID",regulatorioA1713Bean.getLocalidadID());
								    sentenciaStore.setInt("Par_ColoniaID",Utileria.convierteEntero(regulatorioA1713Bean.getColoniaID()));
								    sentenciaStore.setString("Par_CodigoPostal",regulatorioA1713Bean.getCodigoPostal());

								    sentenciaStore.setString("Par_Calle",regulatorioA1713Bean.getCalle());
								    sentenciaStore.setString("Par_NumeroExt",regulatorioA1713Bean.getNumeroExt());
								    sentenciaStore.setString("Par_NumeroInt",regulatorioA1713Bean.getNumeroInt());
								    sentenciaStore.setString("Par_FechaMovimiento",regulatorioA1713Bean.getFechaMovimiento());
								    sentenciaStore.setString("Par_FechaInicioGes",regulatorioA1713Bean.getInicioGestion());

								    sentenciaStore.setString("Par_FechaFinGestion",regulatorioA1713Bean.getConclusionGestion());
								    sentenciaStore.setInt("Par_OrganoID",Utileria.convierteEntero(regulatorioA1713Bean.getOrganoID()));
								    sentenciaStore.setInt("Par_CargoID",Utileria.convierteEntero(regulatorioA1713Bean.getCargoID()));
								    sentenciaStore.setInt("Par_PermanenteID",Utileria.convierteEntero(regulatorioA1713Bean.getPermanenteSupID()));
								    sentenciaStore.setInt("Par_CausaBajaID",Utileria.convierteEntero(regulatorioA1713Bean.getCausaBajaID()));

								    sentenciaStore.setInt("Par_ManifestCumpID",Utileria.convierteEntero(regulatorioA1713Bean.getManifestacionID()));

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
										mensajeTransaccion.setNumero(Utileria.convierteEntero((resultadosStore.getString("NumErr"))));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));

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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de Registro de Regulatorio A1713", e);
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




		// Consulta para el registro del Regulatorio A1713
		public RegulatorioA1713Bean consultaRegistroRegA1713Sofipo( RegulatorioA1713Bean regulatorioA1713Bean, int tipoConsulta){
		RegulatorioA1713Bean regA1713Bean = null;
		try{

			String query = "call REGISTROREGA1713CON(?,?,?,?,?,  ?,?,?,?, ?);";
			Object[] parametros = {
						Utileria.convierteFecha(regulatorioA1713Bean.getFecha()),
						regulatorioA1713Bean.getRegistroID(),
						tipoConsulta,

						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						"consultaRegistroRegA1713Sofipo",
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO
						};


			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGISTROREGA1713CON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					RegulatorioA1713Bean regulatorioA1713Bean = new RegulatorioA1713Bean();

					regulatorioA1713Bean.setFecha(resultSet.getString("Fecha"));
					regulatorioA1713Bean.setRegistroID(resultSet.getString("RegistroID"));
					regulatorioA1713Bean.setTipoMovimientoID(resultSet.getString("TipoMovimientoID"));
					regulatorioA1713Bean.setNombreFuncionario(resultSet.getString("NombreFuncionario"));
					regulatorioA1713Bean.setRfcFuncionario(resultSet.getString("RFC"));

					regulatorioA1713Bean.setCurpFuncionario(resultSet.getString("CURP"));
					regulatorioA1713Bean.setTituloPofID(resultSet.getString("Profesion"));
					regulatorioA1713Bean.setTelefono(resultSet.getString("Telefono"));
					regulatorioA1713Bean.setCorreoElectronico(resultSet.getString("Email"));
					regulatorioA1713Bean.setPaisID(resultSet.getString("PaisID"));

					regulatorioA1713Bean.setEstadoID(resultSet.getString("EstadoID"));
					regulatorioA1713Bean.setMunicipioID(resultSet.getString("MunicipioID"));
					regulatorioA1713Bean.setLocalidadID(resultSet.getString("LocalidadID"));
					regulatorioA1713Bean.setColoniaID(resultSet.getString("ColoniaID"));
					regulatorioA1713Bean.setCodigoPostal(resultSet.getString("CodigoPostal"));

					regulatorioA1713Bean.setCalle(resultSet.getString("Calle"));
					regulatorioA1713Bean.setNumeroExt(resultSet.getString("NumeroExt"));
					regulatorioA1713Bean.setNumeroInt(resultSet.getString("NumeroInt"));
					regulatorioA1713Bean.setFechaMovimiento(resultSet.getString("FechaMovimiento"));
					regulatorioA1713Bean.setInicioGestion(resultSet.getString("FechaInicioGes"));

					regulatorioA1713Bean.setConclusionGestion(resultSet.getString("FechaFinGestion"));
					regulatorioA1713Bean.setOrganoID(resultSet.getString("OrganoID"));
					regulatorioA1713Bean.setCargoID(resultSet.getString("CargoID"));
					regulatorioA1713Bean.setPermanenteSupID(resultSet.getString("PermanenteID"));
					regulatorioA1713Bean.setCausaBajaID(resultSet.getString("CausaBajaID"));

					regulatorioA1713Bean.setManifestacionID(resultSet.getString("ManifestCumpID"));



					return regulatorioA1713Bean;
				}
			});
			regA1713Bean= (RegulatorioA1713Bean)matches.get(0);
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Historial del Regulatorio A1713 ", e);

		}
		return regA1713Bean;
	}




		// Consulta para el registro del Regulatorio A1713
		public List listaRegistroRegA1713Sofipo( RegulatorioA1713Bean regulatorioA1713Bean, int tipoLista){
		List regA1713Bean = null;
		try{

			String query = "call REGISTROREGA1713LIS(?,?,?,?,?,  ?,?,?,?,?);";
			Object[] parametros = {

						regulatorioA1713Bean.getNombreFuncionario(),
						Utileria.convierteFecha(regulatorioA1713Bean.getFecha()),
						tipoLista,

						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						"listaRegistroRegA1713Sofipo",
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO
						};


			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGISTROREGA1713LIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					RegulatorioA1713Bean regulatorioA1713Bean = new RegulatorioA1713Bean();

					regulatorioA1713Bean.setFecha(resultSet.getString("Fecha"));
					regulatorioA1713Bean.setRegistroID(resultSet.getString("RegistroID"));
					regulatorioA1713Bean.setNombreFuncionario(resultSet.getString("NombreFuncionario"));
					regulatorioA1713Bean.setRfcFuncionario(resultSet.getString("RFC"));
					regulatorioA1713Bean.setTipoMovimientoID(resultSet.getString("TipoMovimientoID"));


					return regulatorioA1713Bean;
				}
			});
			regA1713Bean= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Historial del Regulatorio A1713 ", e);

		}
		return regA1713Bean;
	}




		public MensajeTransaccionBean bajaRegistroRegA1713Sofipo(final RegulatorioA1713Bean regulatorioA1713Bean) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				@SuppressWarnings("unchecked")
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {

						// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call REGISTROREGA1713BAJ(?,?,?,?,?,   ?,?,?,?,?,  ?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);


								    sentenciaStore.setInt("Par_RegistroID",Utileria.convierteEntero(regulatorioA1713Bean.getRegistroID()));
								    sentenciaStore.setString("Par_Fecha",regulatorioA1713Bean.getFecha());
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
										mensajeTransaccion.setNumero(Utileria.convierteEntero((resultadosStore.getString("NumErr"))));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));

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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de Registro de Regulatorio A1713", e);
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




		/*
		 * Funciones para generar los reportes
		 */
		/**
		 * Consulta para generar el reporte en Excel regulatorio A1713
		 * @param bean
		 * @param tipoReporte
		 * @return
		 */
		public List <RegulatorioA1713Bean> reporteRegulatorioA1713Sofipo(final RegulatorioA1713Bean bean, int tipoReporte){
			String query = "call REGULATORIOA1713REP(?,?,?,?,?,  ?,?,?,?);";

			Object[] parametros ={
								bean.getFecha(),
								tipoReporte,
					    		parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOA1713REP(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					RegulatorioA1713Bean beanResponse= new RegulatorioA1713Bean();

					beanResponse.setClaveEntidad(resultSet.getString("ClaveEntidad"));
					beanResponse.setSubreporte(resultSet.getString("Reporte"));
					beanResponse.setFecha(resultSet.getString("Fecha"));
					beanResponse.setRegistroID(resultSet.getString("RegistroID"));
					beanResponse.setTipoMovimientoID(resultSet.getString("TipoMovimientoID"));

					beanResponse.setNombreFuncionario(resultSet.getString("NombreFuncionario"));
					beanResponse.setRfcFuncionario(resultSet.getString("RFC"));
					beanResponse.setCurpFuncionario(resultSet.getString("CURP"));
					beanResponse.setTituloPofID(resultSet.getString("Profesion"));
					beanResponse.setCalle(resultSet.getString("Calle"));

					beanResponse.setNumeroExt(resultSet.getString("NumeroExt"));
					beanResponse.setNumeroInt(resultSet.getString("NumeroInt"));
					beanResponse.setNombreColonia(resultSet.getString("Asentamiento"));
					beanResponse.setCodigoPostal(resultSet.getString("CodigoPostal"));
					beanResponse.setLocalidadID(resultSet.getString("LocalidadID"));

					beanResponse.setMunicipioID(resultSet.getString("MunicipioID"));
					beanResponse.setEstadoID(resultSet.getString("EstadoID"));
					beanResponse.setPaisID(resultSet.getString("PaisID"));
					beanResponse.setTelefono(resultSet.getString("Telefono"));
					beanResponse.setCorreoElectronico(resultSet.getString("Email"));

					beanResponse.setFechaMovimiento(resultSet.getString("FechaMovimiento"));
					beanResponse.setInicioGestion(resultSet.getString("FechaInicioGes"));
					beanResponse.setConclusionGestion(resultSet.getString("FechaFinGestion"));
					beanResponse.setOrganoID(resultSet.getString("OrganoID"));
					beanResponse.setCargoID(resultSet.getString("CargoID"));

					beanResponse.setPermanenteSupID(resultSet.getString("PermanenteID"));
					beanResponse.setCausaBajaID(resultSet.getString("CausaBajaID"));
					beanResponse.setManifestacionID(resultSet.getString("ManifestCumpID"));




					return beanResponse ;
				}
			});
			return matches;
		}
		/**
		 * Consulta del reporte regulatorio A1713 version CSV
		 * @param bean
		 * @param tipoReporte
		 * @return
		 */
		public List <RegulatorioA1713Bean> reporteRegulatorioA1713SofipoCsv(final RegulatorioA1713Bean bean, int tipoReporte){
			transaccionDAO.generaNumeroTransaccion();
			String query = "call `REGULATORIOA1713REP`(?,?,?,?,?,  ?,?,?,?);";

			Object[] parametros ={
								bean.getFecha(),
								tipoReporte,
					    		parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOA1713REP(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					RegulatorioA1713Bean beanResponse= new RegulatorioA1713Bean();
					beanResponse.setRenglon(resultSet.getString("Renglon"));

					return beanResponse ;
				}
			});
			return matches;
		}



}