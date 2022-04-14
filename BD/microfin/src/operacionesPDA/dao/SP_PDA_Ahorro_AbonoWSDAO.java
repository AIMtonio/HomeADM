package operacionesPDA.dao;

import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import operacionesPDA.beanWS.request.SP_PDA_Ahorros_AbonoRequest;
import operacionesPDA.beanWS.response.SP_PDA_Ahorros_AbonoResponse;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;


public class SP_PDA_Ahorro_AbonoWSDAO extends BaseDAO{
	public SP_PDA_Ahorro_AbonoWSDAO() {
		super();
	}


/* Realiza la consulta del abono a una cuenta WS */
	public SP_PDA_Ahorros_AbonoResponse abonoCuentaWS(final SP_PDA_Ahorros_AbonoRequest requestBean, final int tipoConsulta) {
	SP_PDA_Ahorros_AbonoResponse abonoCta = new SP_PDA_Ahorros_AbonoResponse();
	transaccionDAO.generaNumeroTransaccionWS();


		abonoCta = (SP_PDA_Ahorros_AbonoResponse) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			SP_PDA_Ahorros_AbonoResponse resultado = new SP_PDA_Ahorros_AbonoResponse();
			try {
				resultado = (SP_PDA_Ahorros_AbonoResponse) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call ABONOCTAWSPRO(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_Num_Socio",Utileria.convierteEntero(requestBean.getNum_Socio()));
								sentenciaStore.setInt("Par_Num_Cta",Utileria.convierteEntero(requestBean.getNum_Cta()));
								sentenciaStore.setDouble("Par_Monto",Utileria.convierteDoble(requestBean.getMonto()));
								sentenciaStore.setString("Par_Fecha_Mov",Utileria.convierteFecha(requestBean.getFecha_Mov()));
								sentenciaStore.setString("Par_Id_Usuario",requestBean.getId_Usuario());
								sentenciaStore.setString("Par_Clave",requestBean.getClave());
								sentenciaStore.setInt("Par_NumCon",tipoConsulta);

								//Parametros de Auditoria
								sentenciaStore.setInt("Par_EmpresaID", Constantes.ENTERO_CERO);
								sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
								sentenciaStore.setString("Aud_FechaActual", Constantes.FECHA_VACIA);
								sentenciaStore.setString("Aud_DireccionIP",Constantes.STRING_VACIO);
								sentenciaStore.setString("Aud_ProgramaID", "operacionesPDA.WS.abonoCuentaWS");
								sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());

								return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																											DataAccessException {
								SP_PDA_Ahorros_AbonoResponse respuestaBean = new SP_PDA_Ahorros_AbonoResponse();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();

									respuestaBean.setCodigoDesc(resultadosStore.getString("CodigoDesc"));
									respuestaBean.setCodigoResp(resultadosStore.getString("CodigoResp"));
									respuestaBean.setEsValido(resultadosStore.getString("EsValido"));
									respuestaBean.setFolioAut(resultadosStore.getString("FolioAut"));
									respuestaBean.setAutFecha(resultadosStore.getString("AutFecha"));
									respuestaBean.setSaldoDisp(resultadosStore.getString("SaldoDisp"));
									respuestaBean.setSaldoTot(resultadosStore.getString("SaldoTot"));

								}else{
									DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
									DateFormat timeFormat = new SimpleDateFormat("HH:mm:ss");
									Date fecha = new Date();
									respuestaBean.setAutFecha(dateFormat.format(fecha)+"T"+timeFormat.format(fecha));
									respuestaBean.setCodigoDesc("Transacción Rechazada");
									respuestaBean.setCodigoResp(String.valueOf(Constantes.ENTERO_CERO));
									respuestaBean.setEsValido("false");
									respuestaBean.setFolioAut(String.valueOf(Constantes.ENTERO_CERO));
									respuestaBean.setSaldoDisp(String.valueOf(Constantes.DOUBLE_VACIO));
									respuestaBean.setSaldoTot(String.valueOf(Constantes.DOUBLE_VACIO));
								}
								return respuestaBean;
							}
						}
					);

					if(resultado ==  null){
						resultado = new SP_PDA_Ahorros_AbonoResponse();
						DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
						DateFormat timeFormat = new SimpleDateFormat("HH:mm:ss");
						Date fecha = new Date();
						resultado.setAutFecha(dateFormat.format(fecha)+"T"+timeFormat.format(fecha));
						resultado.setCodigoDesc("Transacción Rechazada");
						resultado.setCodigoResp(String.valueOf(Constantes.ENTERO_CERO));
						resultado.setEsValido("false");
						resultado.setFolioAut(String.valueOf(Constantes.ENTERO_CERO));
						resultado.setSaldoDisp(String.valueOf(Constantes.DOUBLE_VACIO));
						resultado.setSaldoTot(String.valueOf(Constantes.DOUBLE_VACIO));

						throw new Exception(Constantes.MSG_ERROR + " .SP_PDA_Ahorro_AbonoWSDAO.abonoCuentaWS");
					}else if(Integer.parseInt(resultado.getCodigoResp())!=1){
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error No. " + resultado.getCodigoResp() + ", " +resultado.getCodigoDesc());
						throw new Exception("Transacción Rechazada");
					}

				} catch (Exception e) {

					if (Integer.parseInt(resultado.getCodigoResp())==1) {
						resultado.setCodigoResp("0");
					}
					DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
					DateFormat timeFormat = new SimpleDateFormat("HH:mm:ss");
					Date fecha = new Date();
					resultado.setAutFecha(dateFormat.format(fecha)+"T"+timeFormat.format(fecha));
					resultado.setCodigoDesc(e.getMessage());
					resultado.setCodigoResp(String.valueOf(Constantes.ENTERO_CERO));
					resultado.setEsValido("false");
					resultado.setFolioAut(String.valueOf(Constantes.ENTERO_CERO));
					resultado.setSaldoDisp(String.valueOf(Constantes.DOUBLE_VACIO));
					resultado.setSaldoTot(String.valueOf(Constantes.DOUBLE_VACIO));

					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en abono a cuenta WS", e);
				}
				return resultado;
		}
	});

	return abonoCta;
}

}



