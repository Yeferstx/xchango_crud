package main

import (
	"database/sql"
	"fmt"
	"os"
	"strconv"

	_ "github.com/lib/pq"

	beego "github.com/beego/beego/v2/server/web"

	"xchango_crud/controllers"
	_ "xchango_crud/routers"
)

// en Render los datos vienen en variables de entorno
// en el computador se leen de conf/app.conf
func dato(variable string, clave string, defecto string) string {
	valor := os.Getenv(variable)
	if valor != "" {
		return valor
	}
	return beego.AppConfig.DefaultString(clave, defecto)
}

func main() {
	// Neon pide conexion segura (require), en el computador va disable
	conexion := fmt.Sprintf("host=%s port=%s user=%s password=%s dbname=%s sslmode=%s",
		dato("BD_HOST", "bd_host", "localhost"),
		dato("BD_PUERTO", "bd_puerto", "5432"),
		dato("BD_USUARIO", "bd_usuario", "postgres"),
		dato("BD_CLAVE", "bd_clave", ""),
		dato("BD_NOMBRE", "bd_nombre", "db_xchango"),
		dato("BD_SSL", "bd_ssl", "disable"))

	// sin esto no se puede leer el JSON que llega en POST y PUT
	// va aqui porque en Render no esta el archivo conf/app.conf
	beego.BConfig.CopyRequestBody = true

	// Render dice en que puerto escuchar con la variable PORT
	puerto := os.Getenv("PORT")
	if puerto != "" {
		numero, err := strconv.Atoi(puerto)
		if err == nil {
			beego.BConfig.Listen.HTTPPort = numero
		}
	}

	bd, err := sql.Open("postgres", conexion)
	if err != nil {
		fmt.Println("No se pudo abrir la base de datos:", err)
		return
	}

	// probamos la conexion antes de arrancar
	err = bd.Ping()
	if err != nil {
		fmt.Println("No se pudo conectar a PostgreSQL, revisa conf/app.conf:", err)
		return
	}
	fmt.Println("Conectado a PostgreSQL")

	controllers.BD = bd

	beego.Run()
}
