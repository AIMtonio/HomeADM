package buroCredito.dao;

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
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import buroCredito.bean.TipoInstitucionCirculoBean;
import general.dao.BaseDAO;
import herramientas.Constantes;

public class TipoInstitucionCirculoDAO extends BaseDAO {

	public TipoInstitucionCirculoDAO(){
		super();
	}

	// Consulta Principal
	public TipoInstitucionCirculoBean consultaPrincipal(final TipoInstitucionCirculoBean tipoInstitucionCirculoBean, final int tipoConsulta) {

		TipoInstitucionCirculoBean tipoInstitucion = null;
		//Query con el Store Procedure
		try{
			String query = "CALL CATINSTCIRCREDITOCON(?,?,"
													+"?,?,?,?,?,?,?);";
			Object[] parametros = {
				tipoInstitucionCirculoBean.getClaveID(),
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"TipoInstitucionCirculoDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+"CALL CATINSTCIRCREDITOCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					TipoInstitucionCirculoBean catalogo = new TipoInstitucionCirculoBean();

					catalogo.setClaveID(resultSet.getString("ClaveID"));
					catalogo.setTipoInstitucion(resultSet.getString("TipoInstitucion"));
					catalogo.setEstatus(resultSet.getString("Estatus"));
					return catalogo;
				}
			});

			tipoInstitucion = matches.size() > 0 ? (TipoInstitucionCirculoBean) matches.get(0) : null;

		}catch (Exception exception) {
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en consulta principal de Tipo de Instituciones de Circulo ", exception);
			tipoInstitucion = null;
		}

		return tipoInstitucion;
	}
	
	// Lista Principal Pantalla
	public List<TipoInstitucionCirculoBean> listaPrincipal(final TipoInstitucionCirculoBean tipoInstitucionCirculoBean, final int tipoLista) {

		List<TipoInstitucionCirculoBean> listaInstituciones = null;
		//Query con el Store Procedure
		try{
			String query = "CALL CATINSTCIRCREDITOLIS(?,?,?,"
													+"?,?,?,?,?,?,?);";
			Object[] parametros = {
				tipoInstitucionCirculoBean.getClaveID(),
				tipoInstitucionCirculoBean.getTipoInstitucion(),
				tipoLista,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"TipoInstitucionCirculoDAO.listaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL CATINSTCIRCREDITOLIS(" + Arrays.toString(parametros) + ")");
			List<TipoInstitucionCirculoBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					TipoInstitucionCirculoBean  instituciones = new TipoInstitucionCirculoBean();

					instituciones.setClaveID(resultSet.getString("ClaveID"));
					instituciones.setTipoInstitucion(resultSet.getString("TipoInstitucion"));
					return instituciones;
				}
			});

			listaInstituciones = matches;
		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en la lista de Principal de Tipo de Instituciones de Circulo ", exception);
			listaInstituciones = null;
		}

		return listaInstituciones;
	}
}
