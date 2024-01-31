# Punto 4 Desarrollo python
# Nicolás Adolfo Castillo Betancourt
# Solicitar la cantidad de estudiantes (2 ≤ n ≤ 5)
while True:
    n = int(input("Ingrese la cantidad de estudiantes (entre 2 y 5): "))
    if 2 <= n <= 5:
        break
    else:
        print("La cantidad de estudiantes debe estar entre 2 y 5. Inténtelo nuevamente.")

# Inicializar la lista de estudiantes (Estudiantes)
Estudiantes = []

# Solicitar nombres y calificaciones para cada estudiante y almacenarlos en Estudiantes
for i in range(n):
    nombre = input(f"Ingrese el nombre del estudiante {i + 1}: ")
    
    while True:
        try:
            calificacion = float(input(f"Ingrese la calificación para {nombre}: "))
            break
        except ValueError:
            print("Por favor, ingrese un valor numérico para la calificación.")

    # Agregar nombre y calificación como un estudiante a la lista Estudiantes
    Estudiantes.append([nombre, calificacion])

# Ordenar la lista de estudiantes por calificación de forma ascendente y luego por nombre
Estudiantes.sort(key=lambda x: (x[1], x[0]))

# Encontrar la segunda peor nota
segunda_peor_nota = None
if n >= 2:
    segunda_peor_nota = Estudiantes[1][1]

# Encontrar y mostrar los estudiantes con la segunda peor nota
if segunda_peor_nota is not None:
    estudiantes_segunda_peor = [estudiante[0] for estudiante in Estudiantes if estudiante[1] == segunda_peor_nota]
    print(f"Estudiantes con la segunda peor nota ({segunda_peor_nota}):")
    for estudiante in estudiantes_segunda_peor:
        print(estudiante)
else:
    print("No hay suficientes estudiantes para calcular la segunda peor nota.")
