package soporte.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import soporte.bean.CalculosyOperacionesBean;

import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;
public class CalculosyOperacionesDAO extends BaseDAO{

	public CalculosyOperacionesDAO() {
		super();
		// TODO Auto-generated constructor stub
	}

	// ------------------ Transacciones ------------------------------------------
	/* Alta de Credito */

	public CalculosyOperacionesBean calculosYOperaciones(final CalculosyOperacionesBean calculosyOperacionesBean,final int tipoOperacion) {
		calculosyOperacionesBean.setValorUnoA(calculosyOperacionesBean.getValorUnoA().trim().replaceAll("[,]","").replaceAll("[$]",""));
		calculosyOperacionesBean.setValorDosA(calculosyOperacionesBean.getValorDosA().trim().replaceAll("[,]","").replaceAll("[$]",""));
		calculosyOperacionesBean.setValorUnoB(calculosyOperacionesBean.getValorUnoB().trim().replaceAll("[,]","").replaceAll("[$]",""));
		calculosyOperacionesBean.setValorDosB(calculosyOperacionesBean.getValorDosB().trim().replaceAll("[,]","").replaceAll("[$]",""));
		CalculosyOperacionesBean mensajeBean = new CalculosyOperacionesBean();
		try {
			// Query con el Store Procedure
			mensajeBean = (CalculosyOperacionesBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new CallableStatementCreator() {
					public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
						String query = "call CALCULOSYOPERAPRO(" +
								"?,?,?,?,?, ?,?,?,?,?," +
								"?,?,?,?,?, ?,?,?);";
						CallableStatement sentenciaStore = arg0.prepareCall(query);
						sentenciaStore.setInt("Par_NumeroDecimales",Utileria.convierteEntero(calculosyOperacionesBean.getNumeroDecimales()));
						sentenciaStore.setDouble("Par_ValorUnoA",Utileria.convierteDoble(calculosyOperacionesBean.getValorUnoA()));
						sentenciaStore.setDouble("Par_ValorDosA",Utileria.convierteDoble(calculosyOperacionesBean.getValorDosA()));
						sentenciaStore.setDouble("Par_ValorUnoB",Utileria.convierteDoble(calculosyOperacionesBean.getValorUnoB()));
						sentenciaStore.setDouble("Par_ValorDosB",Utileria.convierteDoble(calculosyOperacionesBean.getValorDosB()));

						sentenciaStore.setInt("Par_NumOpe",tipoOperacion);
						sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
						sentenciaStore.registerOutParameter("Par_ResulDos", Types.DECIMAL);
						sentenciaStore.registerOutParameter("Par_ResulCua", Types.DECIMAL);
						sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);

						sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
						sentenciaStore.setInt("Par_EmpresaID",Constantes.ENTERO_CERO);
						sentenciaStore.setInt("Par_Usuario", Constantes.ENTERO_CERO);
						sentenciaStore.setDate("Par_FechaActual", OperacionesFechas.conversionStrDate(Constantes.FECHA_VACIA));
						sentenciaStore.setString("Par_DireccionIP",Constantes.STRING_VACIO);

						sentenciaStore.setString("Par_ProgramaID","calculosYOperaciones");
						sentenciaStore.setInt("Par_SucursalID",Constantes.ENTERO_CERO);
						sentenciaStore.setLong("Par_NumTransaccion",Constantes.ENTERO_CERO);

					    loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
						return sentenciaStore;
					}
				},new CallableStatementCallback() {
					public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																									DataAccessException {
						CalculosyOperacionesBean mensajeTransaccion = new CalculosyOperacionesBean();
						if(callableStatement.execute()){
							ResultSet resultadosStore = callableStatement.getResultSet();

							resultadosStore.next();
							mensajeTransaccion.setResultadoCuatroDecimales(resultadosStore.getString("ResultadoCuatro"));
							mensajeTransaccion.setResultadoDosDecimales(resultadosStore.getString("ResultadoDos"));
 						}
						return mensajeTransaccion;
					}
				});
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en calculo y operacion credito", e);
		}
		return mensajeBean;
	}
}
