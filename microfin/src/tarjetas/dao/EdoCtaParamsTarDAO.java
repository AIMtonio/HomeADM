package tarjetas.dao;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

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


import tarjetas.bean.EdoCtaParamsTarBean;


import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;


public class EdoCtaParamsTarDAO extends BaseDAO {

	public EdoCtaParamsTarDAO(){
		super();
	}

	/* Modificacion de los datos */
	public MensajeTransaccionBean modificarEdoCtaParamsTar(final EdoCtaParamsTarBean edoCtaParamsTarBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
	mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {

			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					edoCtaParamsTarBean.setTelefonoUEAU(edoCtaParamsTarBean.getTelefonoUEAU().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));
					edoCtaParamsTarBean.setOtrasCiuUEAU(edoCtaParamsTarBean.getOtrasCiuUEAU().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));
		mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
					public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
						String query = "call EDOCTAPARAMSTARMOD(?,?,?,?,?,	 ?,?,?,?,?,"+
																"?,?,?,?,?,  ?,?,?,?,?,"+
																"?,?,?,?,?,	 ?,?,?,?,?,"+
																"?,?,?,?,?,  ?);";
						CallableStatement sentenciaStore = arg0.prepareCall(query);

						sentenciaStore.setString("Par_MontoMin",edoCtaParamsTarBean.getMontoMIn());
						sentenciaStore.setString("Par_RutaExpPDF",edoCtaParamsTarBean.getRutaExpPDF());
						sentenciaStore.setString("Par_RutaReporte",edoCtaParamsTarBean.getRutaReporte());
						sentenciaStore.setString("Par_CiudadUEAUID",edoCtaParamsTarBean.getCiudadUEAUID());
						sentenciaStore.setString("Par_CiudadUEAU",edoCtaParamsTarBean.getCiudadUEAU());

						sentenciaStore.setString("Par_TelefonoUEAU",edoCtaParamsTarBean.getTelefonoUEAU());
						sentenciaStore.setString("Par_OtrasCiuUEAU",edoCtaParamsTarBean.getOtrasCiuUEAU());
						sentenciaStore.setString("Par_HorarioUEAU",edoCtaParamsTarBean.getHorarioUEAU());
						sentenciaStore.setString("Par_DireccionUEAU",edoCtaParamsTarBean.getDireccionUEAU());
						sentenciaStore.setString("Par_CorreoUEAU",edoCtaParamsTarBean.getCorreoUEAU());

						sentenciaStore.setString("Par_RutaCBB",edoCtaParamsTarBean.getRutaCBB());
						sentenciaStore.setString("Par_RutaCFDI",edoCtaParamsTarBean.getRutaCFDI());
						sentenciaStore.setString("Par_RutaLogo",edoCtaParamsTarBean.getRutaLogo());
						sentenciaStore.setString("Par_TipoCuentas",edoCtaParamsTarBean.getTipoCuentaID());
						sentenciaStore.setString("Par_ExtTelefonoPart", edoCtaParamsTarBean.getExtTelefonoPart());
						sentenciaStore.setString("Par_ExtTelefono",edoCtaParamsTarBean.getExtTelefono());

						sentenciaStore.setString("Par_EnvioAutomatico",edoCtaParamsTarBean.getEnvioAutomatico());
						sentenciaStore.setString("Par_CorreoRemitente",edoCtaParamsTarBean.getCorreoRemitente());
						sentenciaStore.setString("Par_ServidorSMTP",edoCtaParamsTarBean.getServidorSMTP());
						sentenciaStore.setInt("Par_PuertoSMTP",Utileria.convierteEntero(edoCtaParamsTarBean.getPuertoSMTP()));
						sentenciaStore.setString("Par_UsuarioRemitente",edoCtaParamsTarBean.getUsuarioRemitente());
						sentenciaStore.setString("Par_Contrasenia",edoCtaParamsTarBean.getContraseniaRemitente());
						sentenciaStore.setString("Par_Asunto",edoCtaParamsTarBean.getAsunto());
						sentenciaStore.setString("Par_CuerpoTexto",edoCtaParamsTarBean.getCuerpoTexto());
						sentenciaStore.setString("Par_RequiereAut",edoCtaParamsTarBean.getRequiereAut());
						sentenciaStore.setString("Par_TipoAut",edoCtaParamsTarBean.getTipoAut());

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
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
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
					});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				}catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion de parametros", e);
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	// consulta  principal de parametros estado de cuenta tarjetas
	public EdoCtaParamsTarBean consultaPrincipal(int tipoConsulta) {
		EdoCtaParamsTarBean edoCtaParamsTar = null;

		try{
			String query = "call EDOCTATDCPARAMSCON(?,?,?,?,?, ?,?,?);";
			Object[] parametros = {
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									OperacionesFechas.FEC_VACIA,
									Constantes.STRING_VACIO,
									"consultaPrincipal",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call EDOCTATDCPARAMSCON(" + Arrays.toString(parametros) +")");
List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					EdoCtaParamsTarBean edoCtaParamsTar = new EdoCtaParamsTarBean();

					edoCtaParamsTar.setMontoMIn(resultSet.getString("MontoMin"));
					edoCtaParamsTar.setRutaExpPDF(resultSet.getString("RutaExpPDF"));
					edoCtaParamsTar.setRutaReporte(resultSet.getString("RutaReporte"));
					edoCtaParamsTar.setCiudadUEAUID(resultSet.getString("CiudadUEAUID"));
					edoCtaParamsTar.setCiudadUEAU(resultSet.getString("CiudadUEAU"));
					edoCtaParamsTar.setTelefonoUEAU(resultSet.getString("TelefonoUEAU"));
					edoCtaParamsTar.setOtrasCiuUEAU(resultSet.getString("OtrasCiuUEAU"));
					edoCtaParamsTar.setHorarioUEAU(resultSet.getString("HorarioUEAU"));
					edoCtaParamsTar.setDireccionUEAU(resultSet.getString("DireccionUEAU"));
					edoCtaParamsTar.setCorreoUEAU(resultSet.getString("CorreoUEAU"));
					edoCtaParamsTar.setRutaCBB(resultSet.getString("RutaCBB"));
					edoCtaParamsTar.setRutaCFDI(resultSet.getString("RutaCFDI"));
					edoCtaParamsTar.setRutaLogo(resultSet.getString("RutaLogo"));
					edoCtaParamsTar.setExtTelefonoPart(resultSet.getString("ExtTelefonoPart"));
					edoCtaParamsTar.setExtTelefono(resultSet.getString("ExtTelefono"));
					edoCtaParamsTar.setTipoCuentaID(resultSet.getString("TipoCuentaID"));

					edoCtaParamsTar.setEnvioAutomatico(resultSet.getString("EnvioAutomatico"));
					edoCtaParamsTar.setCorreoRemitente(resultSet.getString("CorreoRemitente"));
					edoCtaParamsTar.setServidorSMTP(resultSet.getString("ServidorSMTP"));
					edoCtaParamsTar.setPuertoSMTP(resultSet.getString("PuertoSMTP"));
					edoCtaParamsTar.setUsuarioRemitente(resultSet.getString("UsuarioRemitente"));
					edoCtaParamsTar.setContraseniaRemitente(resultSet.getString("ContraseniaRemitente"));
					edoCtaParamsTar.setAsunto(resultSet.getString("Asunto"));
					edoCtaParamsTar.setCuerpoTexto(resultSet.getString("CuerpoTexto"));
					edoCtaParamsTar.setRequiereAut(resultSet.getString("RequiereAut"));
					edoCtaParamsTar.setTipoAut(resultSet.getString("TipoAut"));
					edoCtaParamsTar.setInstitucionID(resultSet.getString("InstitucionID"));
					edoCtaParamsTar.setMesProceso("MesProceso");

					return edoCtaParamsTar;
				}
			});
			edoCtaParamsTar= matches.size() > 0 ? (EdoCtaParamsTarBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta Principal del Estado de Cuenta", e);
		}
		return edoCtaParamsTar;
	}



}
