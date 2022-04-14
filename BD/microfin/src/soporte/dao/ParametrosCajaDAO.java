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
import soporte.bean.ParametrosCajaBean;

public class ParametrosCajaDAO extends BaseDAO {

	public ParametrosCajaDAO(){
		super();
	}
	/*=============================== METODOS ==================================*/
	/* Consuta Principal (por empresaID), obtiene todos los parametros de caja*/
	public ParametrosCajaBean consultaPrincipal(ParametrosCajaBean parametrosCaja,int tipoConsulta) {
		ParametrosCajaBean parametrosCajaBean= new ParametrosCajaBean();

		try{
			/*Query con el Store Procedure */
			String query = "call PARAMETROSCAJACON(?,?,?,?,?, ?,?,?);";

			Object[] parametros = { parametrosCaja.getEmpresaID(),
									tipoConsulta,
									Constantes.ENTERO_CERO,		//	aud_usuario
									Constantes.FECHA_VACIA,		//	fechaActual
									Constantes.STRING_VACIO,	// 	direccionIP
									Constantes.STRING_VACIO, 	//	programaID
									Constantes.ENTERO_CERO,		// 	sucursal
									Constantes.ENTERO_CERO };	//	numTransaccion

			/*Registra el  inf. del log */
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMETROSCAJACON(" + Arrays.toString(parametros) + ")");

			/*E]ecuta el query y setea los valores al bean*/
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
							ParametrosCajaBean parametrosCajaBean = new ParametrosCajaBean();

							parametrosCajaBean.setEmpresaID(resultSet.getString("EmpresaID"));
							parametrosCajaBean.setCtaOrdinaria(resultSet.getString("CtaOrdinaria"));
							parametrosCajaBean.setCtaProtecCre(resultSet.getString("CtaProtecCre"));
							parametrosCajaBean.setCtaProtecCta(resultSet.getString("CtaProtecCta"));
							parametrosCajaBean.setHaberExSocios(resultSet.getString("HaberExsocios"));
							parametrosCajaBean.setCtaContaPROFUN(resultSet.getString("CtaContaPROFUN"));
							parametrosCajaBean.setTipoCtaProtec(resultSet.getString("TipoCtaProtec"));
							parametrosCajaBean.setMontoMaxProtec(resultSet.getString("MontoMaxProtec"));
							parametrosCajaBean.setMontoPROFUN(resultSet.getString("MontoPROFUN"));
							parametrosCajaBean.setAporteMaxPROFUN(resultSet.getString("AporteMaxPROFUN"));

							parametrosCajaBean.setMontoApoyoSRVFUN(resultSet.getString("MontoApoyoSRVFUN"));
							parametrosCajaBean.setMonApoFamSRVFUN(resultSet.getString("monApoFamSRVFUN"));
							parametrosCajaBean.setPerfilAutoriSRVFUN(resultSet.getString("PerfilAutoriSRVFUN"));
							parametrosCajaBean.setEdadMaximaSRVFUN(resultSet.getString("EdadMaximaSRVFUN"));
							parametrosCajaBean.setTiempoMinimoSRVFUN(resultSet.getString("TiempoMinimoSRVFUN"));
							parametrosCajaBean.setMesesValAhoSRVFUN(resultSet.getString("MesesValAhoSRVFUN"));
							parametrosCajaBean.setSaldoMinMesSRVFUN(resultSet.getString("SaldoMinMesSRVFUN"));
							parametrosCajaBean.setCtaContaSRVFUN(resultSet.getString("CtaContaSRVFUN"));
							parametrosCajaBean.setRolAutoApoyoEsc(resultSet.getString("RolAutoApoyoEsc"));
							parametrosCajaBean.setTipoCtaApoyoEscMay(resultSet.getString("TipoCtaApoyoEscMay"));
							parametrosCajaBean.setTipoCtaApoyoEscMen(resultSet.getString("TipoCtaApoyoEscMen"));

							parametrosCajaBean.setCtaContaApoyoEsc(resultSet.getString("CtaContaApoyoEsc"));
							parametrosCajaBean.setMesInicioAhoCons(resultSet.getString("MesInicioAhoCons"));
							parametrosCajaBean.setMontoMinMesApoyoEsc(resultSet.getString("MontoMinMesApoyoEsc"));
							parametrosCajaBean.setPorcentajeCob(resultSet.getString("PorcentajeCob"));
							parametrosCajaBean.setCoberturaMin(resultSet.getString("CoberturaMin"));
							parametrosCajaBean.setCompromisoAho(resultSet.getString("CompromisoAhorro"));
							parametrosCajaBean.setMaxAtraPagPROFUN(resultSet.getString("MaxAtraPagPROFUN"));
							parametrosCajaBean.setPerfilAutoriProtec(resultSet.getString("PerfilAutoriProtec"));
							parametrosCajaBean.setPerfilCancelPROFUN(resultSet.getString("PerfilCancelPROFUN"));
							parametrosCajaBean.setEjecutivoFR(resultSet.getString("EjecutivoFR"));

							parametrosCajaBean.setTipoCtaBeneCancel(resultSet.getString("TipoCtaBeneCancel"));
							parametrosCajaBean.setCuentaVista(resultSet.getString("CuentaVista"));
							parametrosCajaBean.setCtaContaPerdida(resultSet.getString("CtaContaPerdida"));
							parametrosCajaBean.setCCHaberesEx(resultSet.getString("CCHaberesEx"));
							parametrosCajaBean.setCCProtecAhorro(resultSet.getString("CCProtecAhorro"));
							parametrosCajaBean.setCCServifun(resultSet.getString("CCServifun"));
							parametrosCajaBean.setCCApoyoEscolar(resultSet.getString("CCApoyoEscolar"));
							parametrosCajaBean.setCCContaPerdida(resultSet.getString("CCContaPerdida"));

							parametrosCajaBean.setGastosRural(resultSet.getString("GastosRural"));
							parametrosCajaBean.setGastosUrbana(resultSet.getString("GastosUrbana"));
							parametrosCajaBean.setIDGastoAlimenta(resultSet.getString("IDGastoAlimenta"));
					    	parametrosCajaBean.setGastosPasivos(resultSet.getString("GastosPasivos"));

							parametrosCajaBean.setTipoCtaProtecMen(resultSet.getString("TipoCtaProtecMen"));
							parametrosCajaBean.setEdadMinimaCliMen(resultSet.getString("EdadMinimaCliMen"));
							parametrosCajaBean.setEdadMaximaCliMen(resultSet.getString("EdadMaximaCliMen"));
							parametrosCajaBean.setPuntajeMinimo(resultSet.getString("PuntajeMinimo"));
							parametrosCajaBean.setIdGastoAlimenta(resultSet.getString("IdGastoAlimenta"));
							parametrosCajaBean.setVersionWS(resultSet.getString("VersionWS"));
							parametrosCajaBean.setRolCancelaCheque(resultSet.getString("RolCancelaCheque"));

							parametrosCajaBean.setCodCooperativa(resultSet.getString("CodCooperativa"));
							parametrosCajaBean.setCodMoneda(resultSet.getString("CodMoneda"));
							parametrosCajaBean.setCodUsuario(resultSet.getString("CodUsuario"));
							parametrosCajaBean.setPermiteAdicional(resultSet.getString("PermiteAdicional"));

							parametrosCajaBean.setTipoProdCap(resultSet.getString("TipoProdCap"));
							parametrosCajaBean.setAntigueSocio(resultSet.getString("AntigueSocio"));
							parametrosCajaBean.setMontoAhoMes(resultSet.getString("MontoAhoMes"));
							parametrosCajaBean.setImpMinParSoc(resultSet.getString("ImpMinParSoc"));
							parametrosCajaBean.setMesesEvalAho(resultSet.getString("MesesEvalAho"));
							parametrosCajaBean.setValidaCredAtras(resultSet.getString("ValidaCredAtras"));
							parametrosCajaBean.setValidaGaranLiq(resultSet.getString("ValidaGaranLiq"));

							parametrosCajaBean.setMesesConsPago(resultSet.getString("MesesConsPago"));

							parametrosCajaBean.setMontoMaxActCom(resultSet.getString("montoMaxActCom"));
							parametrosCajaBean.setMontoMinActCom(resultSet.getString("montoMinActCom"));


							return parametrosCajaBean;

						}// trows ecexeption
			});// fin de consulta
	parametrosCajaBean= matches.size() > 0 ? (ParametrosCajaBean) matches.get(0) : null;

			/*Maneja la exception y registra el log de error */
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta principal de parametros caja", e);
		}


		/*Retorna un objeto cargado de datos */
		return parametrosCajaBean;
	}// consultaPrincipal



			/* Consuta los parametros de apoyo escolar*/
			public ParametrosCajaBean consultaParamApoyoEsc(ParametrosCajaBean parametrosCaja,int tipoConsulta) {
				ParametrosCajaBean parametrosCajaBean= new ParametrosCajaBean();

				try{
					/*Query con el Store Procedure */
					String query = "call PARAMETROSCAJACON(?,?,?,?,?, ?,?,?);";

					Object[] parametros = { parametrosCaja.getEmpresaID(),
											tipoConsulta,
											Constantes.ENTERO_CERO,		//	aud_usuario
											Constantes.FECHA_VACIA,		//	fechaActual
											Constantes.STRING_VACIO,	// 	direccionIP
											Constantes.STRING_VACIO, 	//	programaID
											Constantes.ENTERO_CERO,		// 	sucursal
											Constantes.ENTERO_CERO };	//	numTransaccion

					/*Registra el  inf. del log */
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMETROSCAJACON(" + Arrays.toString(parametros) + ")");

					/*E]ecuta el query y setea los valores al bean*/
					List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
							public Object mapRow(ResultSet resultSet, int rowNum)
								throws SQLException {
										ParametrosCajaBean parametrosCajaBean = new ParametrosCajaBean();

										parametrosCajaBean.setEmpresaID(resultSet.getString("EmpresaID"));
										parametrosCajaBean.setRolAutoApoyoEsc(resultSet.getString("RolAutoApoyoEsc"));
										parametrosCajaBean.setTipoCtaApoyoEscMay(resultSet.getString("TipoCtaApoyoEscMay"));
										parametrosCajaBean.setTipoCtaApoyoEscMen(resultSet.getString("TipoCtaApoyoEscMen"));
										parametrosCajaBean.setCtaContaApoyoEsc(resultSet.getString("CtaContaApoyoEsc"));
										parametrosCajaBean.setMesInicioAhoCons(resultSet.getString("MesInicioAhoCons"));
										parametrosCajaBean.setMontoMinMesApoyoEsc(resultSet.getString("MontoMinMesApoyoEsc"));

										return parametrosCajaBean;
								}// trows ecexeption
					});// fin de consulta


			parametrosCajaBean= matches.size() > 0 ? (ParametrosCajaBean) matches.get(0) : null;

			/*Maneja la exception y registra el log de error */
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta parametros de apoyo escolar", e);
		}


		/*Retorna un objeto cargado de datos */
		return parametrosCajaBean;
	}// consulta




			/* Consuta de Version de WS */
			public ParametrosCajaBean consultaVersionWS(ParametrosCajaBean parametrosCaja,int tipoConsulta) {
				ParametrosCajaBean parametrosCajaBean= new ParametrosCajaBean();

				try{
					/*Query con el Store Procedure */
					String query = "call PARAMETROSCAJACON(?,?,?,?,?, ?,?,?);";

					Object[] parametros = { parametrosCaja.getEmpresaID(),
											tipoConsulta,
											Constantes.ENTERO_CERO,		//	aud_usuario
											Constantes.FECHA_VACIA,		//	fechaActual
											Constantes.STRING_VACIO,	// 	direccionIP
											Constantes.STRING_VACIO, 	//	programaID
											Constantes.ENTERO_CERO,		// 	sucursal
											Constantes.ENTERO_CERO };	//	numTransaccion

					/*Registra el  inf. del log */
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMETROSCAJACON(" + Arrays.toString(parametros) + ")");

					/*E]ecuta el query y setea los valores al bean */
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get("microfin")).query(query,parametros  ,new RowMapper() {
							public Object mapRow(ResultSet resultSet, int rowNum)
								throws SQLException {
										ParametrosCajaBean parametrosCajaBean = new ParametrosCajaBean();

										parametrosCajaBean.setVersionWS(resultSet.getString("VersionWS"));

										return parametrosCajaBean;
								}// trows ecexeption
					});// fin de consulta


			parametrosCajaBean= matches.size() > 0 ? (ParametrosCajaBean) matches.get(0) : null;

			/*Maneja la exception y registra el log de error */
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta version de WS", e);
		}


		/*Retorna un objeto cargado de datos */
		return parametrosCajaBean;
	}// consulta




	/* Modificacion de todos los parametros CAJA */
	public MensajeTransaccionBean modificar(final ParametrosCajaBean parametrosCajaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		transaccionDAO.generaNumeroTransaccion();











			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					/* Query con el Store Procedure */
				mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
						String query = "call PARAMETROSCAJAMOD(" +
															"?,?,?,?,?, ?,?,?,?,?," +
															"?,?,?,?,?, ?,?,?,?,?," +
															"?,?,?,?,?, ?,?,?,?,?," +
															"?,?,?,?,?,	?,?,?,?,?," +
															"?,?,?,?,?, ?,?,?,?,?," +
															"?,?,?,?,?, ?,?,?,?,?,"	+
															"?,?,?,?,?, ?,?,?,?,?," +
															"?,?);";



								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_EmpresaID",Utileria.convierteEntero(parametrosCajaBean.getEmpresaID()));
								sentenciaStore.setString("Par_CtaProtecCre", parametrosCajaBean.getCtaProtecCre());
								sentenciaStore.setString("Par_CtaProtecCta",parametrosCajaBean.getCtaProtecCta());
								sentenciaStore.setString("Par_HaberExSocios",parametrosCajaBean.getHaberExSocios());
								sentenciaStore.setString("Par_CtaContaPROFUN",parametrosCajaBean.getCtaContaPROFUN());
								sentenciaStore.setInt("Par_TipoCtaProtec",Utileria.convierteEntero(parametrosCajaBean.getTipoCtaProtec()));
								sentenciaStore.setDouble("Par_MontoMaxProtec",Utileria.convierteDoble(parametrosCajaBean.getMontoMaxProtec()));
								sentenciaStore.setDouble("Par_MontoPROFUN",Utileria.convierteDoble(parametrosCajaBean.getMontoPROFUN()));
								sentenciaStore.setDouble("Par_AporteMaxPROFUN",Utileria.convierteDoble(parametrosCajaBean.getAporteMaxPROFUN()));
								sentenciaStore.setInt("Par_MaxAtraPagPROFUN",Utileria.convierteEntero(parametrosCajaBean.getMaxAtraPagPROFUN()));

								sentenciaStore.setInt("Par_PerfilCancelPROFUN",Utileria.convierteEntero(parametrosCajaBean.getPerfilCancelPROFUN()));
								sentenciaStore.setDouble("Par_MontoApoyoSRVFUN",Utileria.convierteDoble(parametrosCajaBean.getMontoApoyoSRVFUN()));
								sentenciaStore.setDouble("Par_MonApoFamSRVFUN",Utileria.convierteDoble(parametrosCajaBean.getMonApoFamSRVFUN()));
								sentenciaStore.setInt("Par_PerfilAutoriSRVFUN",Utileria.convierteEntero(parametrosCajaBean.getPerfilAutoriSRVFUN()));
								sentenciaStore.setInt("Par_EdadMaximaSRVFUN",Utileria.convierteEntero(parametrosCajaBean.getEdadMaximaSRVFUN()));
								sentenciaStore.setInt("Par_TiempoMinimoSRVFUN",Utileria.convierteEntero(parametrosCajaBean.getTiempoMinimoSRVFUN()));
								sentenciaStore.setInt("Par_MesesValAhoSRVFUN",Utileria.convierteEntero(parametrosCajaBean.getMesesValAhoSRVFUN()));
								sentenciaStore.setDouble("Par_SaldoMinMesSRVFUN",Utileria.convierteDoble(parametrosCajaBean.getSaldoMinMesSRVFUN()));
								sentenciaStore.setString("Par_CtaContaSRVFUN",parametrosCajaBean.getCtaContaSRVFUN());
								sentenciaStore.setInt("Par_RolAutoApoyoEsc",Utileria.convierteEntero(parametrosCajaBean.getRolAutoApoyoEsc()));
								sentenciaStore.setInt("Par_TipoCtaApoyoEscMay",Utileria.convierteEntero(parametrosCajaBean.getTipoCtaApoyoEscMay()));

								sentenciaStore.setInt("Par_TipoCtaApoyoEscMen",Utileria.convierteEntero(parametrosCajaBean.getTipoCtaApoyoEscMen()));
								sentenciaStore.setInt("Par_MesInicioAhoCons",Utileria.convierteEntero(parametrosCajaBean.getMesInicioAhoCons()));
								sentenciaStore.setDouble("Par_MontoMinMesApoyoEsc",Utileria.convierteDoble(parametrosCajaBean.getMontoMinMesApoyoEsc()));
								sentenciaStore.setString("Par_CtaContaApoyoEsc",parametrosCajaBean.getCtaContaApoyoEsc());
								sentenciaStore.setDouble("Par_CompromisoAho",Utileria.convierteDoble(parametrosCajaBean.getCompromisoAho()));
								sentenciaStore.setInt("Par_PerfilAutoriProtec",Utileria.convierteEntero(parametrosCajaBean.getPerfilAutoriProtec()));
								sentenciaStore.setDouble("Par_PorcentajeCob",Utileria.convierteDoble(parametrosCajaBean.getPorcentajeCob()));
								sentenciaStore.setDouble("Par_CoberturaMin",Utileria.convierteDoble(parametrosCajaBean.getCoberturaMin()));
								sentenciaStore.setInt("Par_CtaOrdinaria",Utileria.convierteEntero(parametrosCajaBean.getCtaOrdinaria()));
								sentenciaStore.setInt("Par_TipoCtaBeneCancel",Utileria.convierteEntero(parametrosCajaBean.getTipoCtaBeneCancel()));

								sentenciaStore.setInt("Par_CuentaVista",Utileria.convierteEntero(parametrosCajaBean.getCuentaVista()));
								sentenciaStore.setString("Par_CtaContaPerdida",parametrosCajaBean.getCtaContaPerdida());
								sentenciaStore.setString("Par_CCHaberesEx",parametrosCajaBean.getCCHaberesEx());
								sentenciaStore.setString("Par_CCProtecAhorro",parametrosCajaBean.getCCProtecAhorro());
								sentenciaStore.setString("Par_CCServifun",parametrosCajaBean.getCCServifun());
								sentenciaStore.setString("Par_CCApoyoEscolar",parametrosCajaBean.getCCApoyoEscolar());
								sentenciaStore.setString("Par_CCContaPerdida",parametrosCajaBean.getCCContaPerdida());
								sentenciaStore.setInt("Par_EjecutivoFR",Utileria.convierteEntero(parametrosCajaBean.getEjecutivoFR()));
								sentenciaStore.setDouble("Par_GastosRural",Utileria.convierteDoble(parametrosCajaBean.getGastosRural()));
								sentenciaStore.setDouble("Par_GastosUrbana",Utileria.convierteDoble(parametrosCajaBean.getGastosUrbana()));


								sentenciaStore.setInt("Par_TipoCtaProtecMen",Utileria.convierteEntero(parametrosCajaBean.getTipoCtaProtecMen()));
								sentenciaStore.setInt("Par_EdadMinimaCliMen",Utileria.convierteEntero(parametrosCajaBean.getEdadMinimaCliMen()));
								sentenciaStore.setInt("Par_EdadMaximaCliMen",Utileria.convierteEntero(parametrosCajaBean.getEdadMaximaCliMen()));

								sentenciaStore.setString("Par_GastosPasivos",parametrosCajaBean.getGastosPasivos());
								sentenciaStore.setDouble("Par_PuntajeMinimo",Utileria.convierteDoble(parametrosCajaBean.getPuntajeMinimo()));
								sentenciaStore.setDouble("Par_IdGastoAlimenta",Utileria.convierteDoble(parametrosCajaBean.getIdGastoAlimenta()));
								sentenciaStore.setString("Par_VersionWS",parametrosCajaBean.getVersionWS());
								sentenciaStore.setInt("Par_RolCancelaCheq",Utileria.convierteEntero(parametrosCajaBean.getRolCancelaCheque()));

								sentenciaStore.setString("Par_CodCooperativa",parametrosCajaBean.getCodCooperativa());
								sentenciaStore.setString("Par_CodMoneda", parametrosCajaBean.getCodMoneda());
								sentenciaStore.setString("Par_CodUsuario", parametrosCajaBean.getCodUsuario());
								sentenciaStore.setString("Par_PermiteAdicional", parametrosCajaBean.getPermiteAdicional());
								sentenciaStore.setString("Par_TipoProdCap", parametrosCajaBean.getTipoProdCap());
								sentenciaStore.setInt("Par_AntigueSocio", Utileria.convierteEntero(parametrosCajaBean.getAntigueSocio()));
								sentenciaStore.setDouble("Par_MontoAhoMes", Utileria.convierteDoble(parametrosCajaBean.getMontoAhoMes()));
								sentenciaStore.setDouble("Par_ImpMinParSoc", Utileria.convierteDoble(parametrosCajaBean.getImpMinParSoc()));
								sentenciaStore.setInt("Par_MesesEvalAho", Utileria.convierteEntero(parametrosCajaBean.getMesesEvalAho()));
								sentenciaStore.setString("Par_ValidaCredAtras", parametrosCajaBean.getValidaCredAtras());
								sentenciaStore.setString("Par_ValidaGaranLiq", parametrosCajaBean.getValidaGaranLiq());

								sentenciaStore.setInt("Par_MesesConsPago",Utileria.convierteEntero(parametrosCajaBean.getMesesConsPago()));
								sentenciaStore.setDouble("Par_montoMaxActCom",Utileria.convierteDoble(parametrosCajaBean.getMontoMaxActCom()));
								sentenciaStore.setDouble("Par_montoMinActCom",Utileria.convierteDoble(parametrosCajaBean.getMontoMinActCom()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());

								sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMETROSCAJAMOD(" + sentenciaStore.toString() + ")");

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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modifica parametros de CAJA", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();

					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

}//class
