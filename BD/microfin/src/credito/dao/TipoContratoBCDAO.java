package credito.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.dao.BaseDAO;
import gestionComecial.bean.PuestosBean;
import herramientas.Constantes;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;

import credito.bean.TipoContratoBCBean;


public class TipoContratoBCDAO extends BaseDAO{

	java.sql.Date fecha = null;

	public TipoContratoBCDAO() {
		super();
	}


	//Query con el Store Procedure Para la consulta principal para construir el nombre

	public TipoContratoBCBean consultaPrincipal(final TipoContratoBCBean tipoContratoBCBean, final int tipoConsulta){
		TipoContratoBCBean contratoBean =null;

		try {

			contratoBean = (TipoContratoBCBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

							String query = "call BUCRETIPCONTCON(?,?,?,?,?,?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setString("Par_TipoContratoBCID",tipoContratoBCBean.getTipoContratoBCID());

							sentenciaStore.setInt("Par_NumCon",tipoConsulta);
							sentenciaStore.setInt("Aud_EmpresaID",Constantes.ENTERO_CERO);
							sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
							sentenciaStore.setDate("Aud_FechaActual", fecha);
							sentenciaStore.setString("Aud_DireccionIP",Constantes.STRING_VACIO);
							sentenciaStore.setString("Aud_ProgramaID","consultaNombArch");
							sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
							sentenciaStore.setLong("Aud_NumTransaccion",Constantes.ENTERO_CERO);
							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																											DataAccessException {
							TipoContratoBCBean tipoContrato = new TipoContratoBCBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								tipoContrato.setDescripcion(resultadosStore.getString(1));


							}
							return tipoContrato;
						}
					});
		return contratoBean;
	} catch (Exception e) {
		e.printStackTrace();
		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta principal para construir el nombre", e);
		return null;
	}
}



	public List listaAlfanumerica(TipoContratoBCBean tipoContratoBCBean, int tipoLista){
		String query = "call BUCRETIPCONTLIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
					tipoContratoBCBean.getTipoContratoBCID(),
					tipoContratoBCBean.getDescripcion(),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"TipoContratoBCDAO.listaAlfanumerica",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call BUCRETIPCONTLIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TipoContratoBCBean contratoBean = new TipoContratoBCBean();
				contratoBean.setTipoContratoBCID(resultSet.getString(1));
				contratoBean.setDescripcion(resultSet.getString(2));
				return contratoBean;

			}
		});
		return matches;
		}

}
