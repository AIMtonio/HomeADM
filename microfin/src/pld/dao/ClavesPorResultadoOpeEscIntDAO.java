package pld.dao;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;

import pld.bean.ClavesPorResultadoOpeEscIntBean;
import pld.bean.ClavesPorResultadoOpeEscIntBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class ClavesPorResultadoOpeEscIntDAO extends BaseDAO{
	// Constantes

	// Constructror
	public ClavesPorResultadoOpeEscIntDAO() {
		super();
	}

	//Lista Principal
	public List listaPrincipal(final ClavesPorResultadoOpeEscIntBean clavesPorResultadoOpeEscIntBean,
							   final int tipoLista) {
		List  matchesss = null;
		try{

		//Query con el Store Procedure
		String query = "call PLDCLAPORRESULLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	clavesPorResultadoOpeEscIntBean.getResultadoOpeEscalaIntID(),
								tipoLista,

								 Constantes.ENTERO_CERO,
                                 Constantes.ENTERO_CERO,
                                 Constantes.FECHA_VACIA,
                                 Constantes.STRING_VACIO,
                                 "ClavesPorResultadoOpeEscIntDAO.listaPrincipal",
                                 Constantes.ENTERO_CERO,
                                 Constantes.ENTERO_CERO
                               };

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLDCLAPORRESULLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClavesPorResultadoOpeEscIntBean clavesPorResultadoOpeEscInt = new ClavesPorResultadoOpeEscIntBean();
				clavesPorResultadoOpeEscInt.setResultadoOpeEscalaIntID(resultSet.getString(1));
				clavesPorResultadoOpeEscInt.setClaveJustificacionOpeEscalaIntID(String.valueOf(resultSet.getInt(2)));
				clavesPorResultadoOpeEscInt.setDescripcionJustificacionOpeEscalaInt(resultSet.getString(3));

				return clavesPorResultadoOpeEscInt;
			}
		});

		matchesss = matches;
		} catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista principal de claves por resultado", e);
		}
		return matchesss;
	}

	public ClavesPorResultadoOpeEscIntBean consultaClavesPorResultado(final ClavesPorResultadoOpeEscIntBean clavesPorResultadoOpeEscIntBean, final int tipoConsulta) {
		ClavesPorResultadoOpeEscIntBean escInternoBean;
		try {
			//Query con el Store Procedure
			escInternoBean = (ClavesPorResultadoOpeEscIntBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							@Override
							public CallableStatement createCallableStatement(java.sql.Connection arg0) throws SQLException {
								String query = "call PLDCLAPORRESULCON(?,?,?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_ClaveJustID",Utileria.convierteEntero(clavesPorResultadoOpeEscIntBean.getClaveJustificacionOpeEscalaIntID()));
								sentenciaStore.setInt("Par_NumCon",tipoConsulta);

								sentenciaStore.setInt("Par_EmpresaID",Constantes.ENTERO_CERO);
								sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
								sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",Constantes.STRING_VACIO);
								sentenciaStore.setString("Aud_ProgramaID","consultaClavesPorResultado");
								sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
								sentenciaStore.setLong("Aud_NumTransaccion",Constantes.ENTERO_CERO);
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
								return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
								ClavesPorResultadoOpeEscIntBean clavesPorResultado = new ClavesPorResultadoOpeEscIntBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									clavesPorResultado.setClaveJustificacionOpeEscalaIntID(resultadosStore.getString("ClaveJustEscIntID"));
									clavesPorResultado.setDescripcionJustificacionOpeEscalaInt(resultadosStore.getString("Descripcion"));
								}
								return clavesPorResultado;
							}
						});
			return escInternoBean;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de claves por resultado: ", e);
			return null;
		}
	}
}
