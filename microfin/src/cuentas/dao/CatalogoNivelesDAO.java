package cuentas.dao;

import general.dao.BaseDAO;
import herramientas.Constantes;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import cuentas.bean.CatalogoNivelesBean;


public class CatalogoNivelesDAO extends BaseDAO {
	
	public CatalogoNivelesDAO(){
		super();
	}
	
	//Lista de Niveles para Combo Box	
	public List listaCombo(CatalogoNivelesBean catalogoNivelesBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call CATALOGONIVELESLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	Constantes.STRING_VACIO,
								tipoLista,
								
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATALOGONIVELESLIS(" + Arrays.toString(parametros) + ");");
				
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CatalogoNivelesBean catalogoNiveles = new CatalogoNivelesBean();	
					catalogoNiveles.setNivelID(resultSet.getString("NivelID"));
					catalogoNiveles.setDescripcion(resultSet.getString("Descripcion"));
					return catalogoNiveles;
				}
		});
						
		return matches;
	}

}
