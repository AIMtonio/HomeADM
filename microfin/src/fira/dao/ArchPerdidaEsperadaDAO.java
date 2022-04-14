package fira.dao;

import fira.bean.ArchPerdidaEsperadaBean;
import general.dao.BaseDAO;
import herramientas.Constantes;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

public class ArchPerdidaEsperadaDAO extends BaseDAO{
	public ArchPerdidaEsperadaBean consultaPrincipal(long numeroTransaccion, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call BITACORAREPARCHPERDCON("
				+ "?,?,?,?,?,"
				+ "?,?,?,?);";
		Object[] parametros = {	
				numeroTransaccion,
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				
				Constantes.STRING_VACIO,
				Constantes.STRING_VACIO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call BITACORAREPARCHPERDCON(" + Arrays.toString(parametros) + ");");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ArchPerdidaEsperadaBean archPerdidaEsperadaBean = new ArchPerdidaEsperadaBean();
				archPerdidaEsperadaBean.setRutaCSV(resultSet.getString("RutaArchivoSubido"));
				archPerdidaEsperadaBean.setRutaFinal(resultSet.getString("RutaArchivoReporteG"));
				return archPerdidaEsperadaBean;
			}
		});
		return matches.size() > 0 ? (ArchPerdidaEsperadaBean) matches.get(0) : null;
	}
	public long getNumTransaccion(){
		return transaccionDAO.generaNumeroTransaccionOut();
	}
}
