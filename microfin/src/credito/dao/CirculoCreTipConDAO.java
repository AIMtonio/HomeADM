package credito.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;

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

import credito.bean.CatclasifrepregBean;
import credito.bean.CirculoCreTipConBean;

public class CirculoCreTipConDAO extends BaseDAO{
	public CirculoCreTipConDAO() {
		super();
	}


	//Query de consulta
	public CirculoCreTipConBean consultaPrincipal(final CirculoCreTipConBean circuloCreTipConBean, final int tipoConsulta){
		CirculoCreTipConBean contratoBean =null;
		try {
			contratoBean = (CirculoCreTipConBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(

					new CallableStatementCreator() {
				public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
					String query = "call CIRCULOCRETIPCONCON(" +
							"?,?,?,?,?, ?,?,?,?);";
					CallableStatement sentenciaStore = arg0.prepareCall(query);
					sentenciaStore.setString("Par_TipoContratoCCID",circuloCreTipConBean.getTipoContratoCCID());
					sentenciaStore.setInt("Par_NumCon",tipoConsulta);
					sentenciaStore.setInt("Par_EmpresaID",Constantes.ENTERO_CERO);
					sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
					sentenciaStore.setDate("Aud_FechaActual", OperacionesFechas.conversionStrDate(Constantes.FECHA_VACIA));

					sentenciaStore.setString("Aud_DireccionIP",Constantes.STRING_VACIO);
					sentenciaStore.setString("Aud_ProgramaID","consultaNombArch");
					sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
					sentenciaStore.setLong("Aud_NumTransaccion",Constantes.ENTERO_CERO);
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
					return sentenciaStore;
				}
			},new CallableStatementCallback() {
				public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
					CirculoCreTipConBean tipoContrato = new CirculoCreTipConBean();
					if(callableStatement.execute()){
						ResultSet resultadosStore = callableStatement.getResultSet();

						resultadosStore.next();
						tipoContrato.setTipoContratoCCID(resultadosStore.getString("TipoContratoCCID"));
						tipoContrato.setDescripcion(resultadosStore.getString("Descripcion"));
						}
					return tipoContrato;
				}
			});
			return contratoBean;
		}catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta principal para construir el nombre", e);
			return null;
		}
	}

	public List listaPrincipal(CirculoCreTipConBean circuloCreTipConBean, int tipoLista){
		String query = "call CIRCULOCRETIPCONLIS(" +
				"?,?,?,?,?, ?,?,?,?,?);";
		Object[] parametros = {
					circuloCreTipConBean.getTipoContratoCCID(),
					circuloCreTipConBean.getDescripcion(),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"TipoContratoBCDAO.listaAlfanumerica",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CIRCULOCRETIPCONLIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CirculoCreTipConBean contratoBean = new CirculoCreTipConBean();
				contratoBean.setTipoContratoCCID(resultSet.getString("TipoContratoCCID"));
				contratoBean.setDescripcion(resultSet.getString("Descripcion"));
				return contratoBean;
			}
		});
		return matches;
	}

}
